#if os(Windows)

public import WinSDK
public import CSystemClock

/// The Windows end of ``PlatformClock``.
///
/// Windows has no `clockid_t`, so the id selects a Win32 function rather than naming anything
/// the operating system defines. `CSystemClock` supplies only the calls Swift's `WinSDK` module
/// map leaves unreachable; every reading is turned into a `CompactDuration` here.
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
    var rawID: Int32 {
        self.id.rawValue
    }

    @inlinable
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
            return CompactDuration(
                nanoseconds: (ticks / frequency) * 1_000_000_000
                    + frequency.dividingFullWidth(scaled).quotient
            )
        case .systemTime:
            var time = FILETIME()
            unsafe GetSystemTimeAsFileTime(&time)
            return CompactDuration(
                hundredNanosecondIntervals: time.intervals - Self.fileTimeToUnixEpoch
            )
        case .systemTimePrecise:
            var time = FILETIME()
            unsafe GetSystemTimePreciseAsFileTime(&time)
            return CompactDuration(
                hundredNanosecondIntervals: time.intervals - Self.fileTimeToUnixEpoch
            )
        case .interruptTime:
            let intervals = csystem_clock_windows_query_interrupt_time()
            return CompactDuration(hundredNanosecondIntervals: Int64(intervals))
        case .interruptTimePrecise:
            let intervals = csystem_clock_windows_query_interrupt_time_precise()
            return CompactDuration(hundredNanosecondIntervals: Int64(intervals))
        case .unbiasedInterruptTime:
            let intervals = csystem_clock_windows_query_unbiased_interrupt_time()
            guard intervals >= 0 else {
                return nil
            }
            return CompactDuration(hundredNanosecondIntervals: intervals)
        case .unbiasedInterruptTimePrecise:
            let intervals = csystem_clock_windows_query_unbiased_interrupt_time_precise()
            return CompactDuration(hundredNanosecondIntervals: Int64(intervals))
        case .tickCount:
            return CompactDuration(nanoseconds: Int64(GetTickCount64()) * 1_000_000)
        case .processTime, .threadTime:
            var creation = FILETIME()
            var exit = FILETIME()
            var kernel = FILETIME()
            var user = FILETIME()
            let ok =
                self.id == .processTime
                ? unsafe GetProcessTimes(
                    GetCurrentProcess(),
                    &creation,
                    &exit,
                    &kernel,
                    &user
                )
                : unsafe GetThreadTimes(GetCurrentThread(), &creation, &exit, &kernel, &user)
            guard ok else {
                return nil
            }
            return CompactDuration(hundredNanosecondIntervals: kernel.intervals + user.intervals)
        default:
            return nil
        }
    }

    @inlinable
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
            .threadTime:
            /// One system clock tick. Microsoft documents 0.5 to 15.625 ms, hardware
            /// dependent; 15.625 ms is the usual default.
            return CompactDuration(nanoseconds: 15_625_000)
        default:
            return nil
        }
    }

    /// Windows has no clock-bound wait, so the deadline is unused and the remainder is rounded
    /// up to the millisecond `SleepEx` takes.
    @inlinable
    func sleep(until deadline: CompactDuration, orFor remaining: CompactDuration) {
        var milliseconds: Int64 = 0
        if remaining.nanoseconds > 0 {
            milliseconds = (remaining.nanoseconds + 999_999) / 1_000_000
        }
        milliseconds = min(milliseconds, Int64(INFINITE - 1))
        SleepEx(DWORD(milliseconds), true)
    }
}

extension FILETIME {
    @inlinable
    var intervals: Int64 {
        Int64(bitPattern: UInt64(self.dwHighDateTime) << 32 | UInt64(self.dwLowDateTime))
    }
}

extension CompactDuration {
    /// A count of the 100-nanosecond intervals every Windows time function but `GetTickCount64`
    /// reports.
    @inlinable
    init(hundredNanosecondIntervals intervals: Int64) {
        self.init(nanoseconds: intervals * 100)
    }
}

#endif
