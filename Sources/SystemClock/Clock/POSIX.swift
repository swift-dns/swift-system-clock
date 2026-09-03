#if !os(Windows) && !$Embedded

#if os(WASI)
public import WASILibc
#else
public import CSystemClock
#endif

/// The conversions that every `clock_gettime(2)` platform shares, which is every one Swift supports excluding Windows.
@usableFromInline
enum POSIX {
    @inlinable
    static func duration(from value: timespec) -> CompactDuration? {
        let (seconds, overflow) = Int64(value.tv_sec)
            .multipliedReportingOverflow(by: 1_000_000_000)
        if overflow {
            return nil
        }
        return CompactDuration(nanoseconds: seconds &+ Int64(value.tv_nsec))
    }

    #if !os(WASI)
    @inlinable
    static func duration(from value: timeval) -> CompactDuration? {
        let (seconds, overflow) = Int64(value.tv_sec)
            .multipliedReportingOverflow(by: 1_000_000_000)
        if overflow {
            return nil
        }
        return CompactDuration(nanoseconds: seconds &+ Int64(value.tv_usec) &* 1_000)
    }

    @inlinable
    static func readResourceUsage(
        of selector: Int32
    ) -> (user: CompactDuration, system: CompactDuration)? {
        var usage = rusage()
        guard unsafe csystem_clock_getrusage(selector, &usage) == 0,
            let user = Self.duration(from: usage.ru_utime),
            let system = Self.duration(from: usage.ru_stime)
        else {
            return nil
        }
        return (user, system)
    }
    #endif
}

@available(*, unavailable)
extension POSIX: Sendable {}

#endif
