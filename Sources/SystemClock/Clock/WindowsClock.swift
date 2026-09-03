#if os(Windows) && !$Embedded

public import WinSDK
public import CSystemClock

@usableFromInline
struct WindowsClock: Sendable {
    /// 100-nanosecond intervals between the FILETIME epoch of 1601 and the Unix epoch.
    @usableFromInline
    static var fileTimeToUnixEpoch: Int64 { 116_444_736_000_000_000 }

    @usableFromInline
    let id: WindowsClockID

    @inlinable
    init(id: WindowsClockID) {
        self.id = id
    }

    @inlinable
    @inline(always)
    func read() -> CompactDuration? {
        switch self.id {
        case .performanceCounter:
            let frequency = csystem_clock_windows_query_performance_frequency()
            let ticks = csystem_clock_windows_query_performance_counter()
            guard frequency > 0, ticks >= 0 else {
                return nil
            }
            /// The remainder scaled by a billion overruns 64 bits once the counter passes
            /// 9.22 GHz, so it is divided at full width. The quotient cannot overrun, since
            /// the remainder is below the frequency and so the answer is below a billion.
            let scaled = (ticks % frequency).multipliedFullWidth(by: 1_000_000_000)
            let (seconds, overflow) = (ticks / frequency)
                .multipliedReportingOverflow(by: 1_000_000_000)
            if overflow { return nil }
            let subSeconds = frequency.dividingFullWidth(scaled).quotient
            return CompactDuration(nanoseconds: seconds &+ subSeconds)
        case .systemTime:
            var time = FILETIME()
            unsafe GetSystemTimeAsFileTime(&time)
            return Self.duration(
                hundredNanosecondIntervals: Self.intervals(of: time) &- Self.fileTimeToUnixEpoch
            )
        case .systemTimePrecise:
            var time = FILETIME()
            unsafe GetSystemTimePreciseAsFileTime(&time)
            return Self.duration(
                hundredNanosecondIntervals: Self.intervals(of: time) &- Self.fileTimeToUnixEpoch
            )
        case .interruptTime:
            guard let intervals = Int64(exactly: csystem_clock_windows_query_interrupt_time())
            else {
                return nil
            }
            return Self.duration(hundredNanosecondIntervals: intervals)
        case .interruptTimePrecise:
            guard
                let intervals = Int64(exactly: csystem_clock_windows_query_interrupt_time_precise())
            else {
                return nil
            }
            return Self.duration(hundredNanosecondIntervals: intervals)
        case .unbiasedInterruptTime:
            let intervals = csystem_clock_windows_query_unbiased_interrupt_time()
            guard intervals >= 0 else {
                return nil
            }
            return Self.duration(hundredNanosecondIntervals: intervals)
        case .unbiasedInterruptTimePrecise:
            let rawIntervals = csystem_clock_windows_query_unbiased_interrupt_time_precise()
            guard let intervals = Int64(exactly: rawIntervals) else {
                return nil
            }
            return Self.duration(hundredNanosecondIntervals: intervals)
        case .tickCount:
            guard let milliseconds = Int64(exactly: GetTickCount64()) else {
                return nil
            }
            let (nanoseconds, overflow) = milliseconds.multipliedReportingOverflow(by: 1_000_000)
            if overflow { return nil }
            return CompactDuration(nanoseconds: nanoseconds)
        case .processTime:
            guard let times = Self.readProcessTimes() else {
                return nil
            }
            return Self.sum(times.user, times.system)
        case .threadTime:
            guard let times = Self.readThreadTimes() else {
                return nil
            }
            return Self.sum(times.user, times.system)
        case .processUserTime:
            return Self.readProcessTimes()?.user
        case .processKernelTime:
            return Self.readProcessTimes()?.system
        case .threadUserTime:
            return Self.readThreadTimes()?.user
        case .threadKernelTime:
            return Self.readThreadTimes()?.system
        default:
            return nil
        }
    }

    @inlinable
    @inline(always)
    func resolution() -> CompactDuration? {
        switch self.id {
        case .performanceCounter:
            let frequency = csystem_clock_windows_query_performance_frequency()
            guard frequency > 0 else {
                return nil
            }
            /// Floored at a nanosecond, which is the finest a `CompactDuration` holds, so that
            /// a counter above 1 GHz reports its resolution as one rather than as none.
            return CompactDuration(nanoseconds: max(1_000_000_000 / frequency, 1))
        case .systemTimePrecise, .interruptTimePrecise, .unbiasedInterruptTimePrecise:
            return CompactDuration(nanoseconds: 100)
        case .systemTime, .interruptTime, .unbiasedInterruptTime, .tickCount, .processTime,
            .threadTime, .processUserTime, .processKernelTime, .threadUserTime,
            .threadKernelTime:
            /// One system clock tick. Microsoft documents 0.5 to 15.625 ms, hardware
            /// dependent; 15.625 ms is the usual default.
            return CompactDuration(nanoseconds: 15_625_000)
        default:
            return nil
        }
    }

    @inlinable
    static func readProcessTimes() -> (user: CompactDuration, system: CompactDuration)? {
        var creation = FILETIME()
        var exit = FILETIME()
        var kernelTime = FILETIME()
        var userTime = FILETIME()
        guard
            unsafe GetProcessTimes(GetCurrentProcess(), &creation, &exit, &kernelTime, &userTime),
            let user = Self.duration(hundredNanosecondIntervals: Self.intervals(of: userTime)),
            let system = Self.duration(hundredNanosecondIntervals: Self.intervals(of: kernelTime))
        else {
            return nil
        }
        return (user, system)
    }

    @inlinable
    static func readThreadTimes() -> (user: CompactDuration, system: CompactDuration)? {
        var creation = FILETIME()
        var exit = FILETIME()
        var kernelTime = FILETIME()
        var userTime = FILETIME()
        guard
            unsafe GetThreadTimes(GetCurrentThread(), &creation, &exit, &kernelTime, &userTime),
            let user = Self.duration(hundredNanosecondIntervals: Self.intervals(of: userTime)),
            let system = Self.duration(hundredNanosecondIntervals: Self.intervals(of: kernelTime))
        else {
            return nil
        }
        return (user, system)
    }

    @inlinable
    static func sum(_ user: CompactDuration, _ system: CompactDuration) -> CompactDuration? {
        let (nanoseconds, overflow) = user.nanoseconds.addingReportingOverflow(system.nanoseconds)
        if overflow { return nil }
        return CompactDuration(nanoseconds: nanoseconds)
    }

    @inlinable
    static func intervals(of value: FILETIME) -> Int64 {
        Int64(bitPattern: UInt64(value.dwHighDateTime) << 32 | UInt64(value.dwLowDateTime))
    }

    @inlinable
    static func duration(hundredNanosecondIntervals intervals: Int64) -> CompactDuration? {
        let (nanoseconds, overflow) = intervals.multipliedReportingOverflow(by: 100)
        if overflow { return nil }
        return CompactDuration(nanoseconds: nanoseconds)
    }
}

#endif
