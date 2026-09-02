#if !os(Windows) && !$Embedded

#if canImport(Darwin)
public import Darwin
#elseif canImport(Glibc)
public import Glibc
#elseif canImport(Musl)
public import Musl
#elseif canImport(Android)
public import Android
#elseif canImport(WASILibc)
public import WASILibc
#else
#error("The SystemClock module was unable to identify your C library.")
#endif

#if !os(WASI)
public import CSystemClock
#endif

/// The conversions and the wait that every `clock_gettime(2)` platform shares, which is every
/// one Swift supports excluding Windows.
@usableFromInline
enum POSIX {
    @inlinable
    static func duration(from value: timespec) -> CompactDuration {
        /// This can overflow for year 2262, or if the number is too big and reports
        /// something else (for example imagine cumulative CPU time of lots of CPU cores).
        /// Therefore we won't do unchecked arithmetic here just to be safe.
        let seconds = Int64(value.tv_sec) * 1_000_000_000
        let nanoseconds = Int64(value.tv_nsec)
        /// Checked math here is unnecessary because `seconds` calc would overflow first anyway.
        return CompactDuration(nanoseconds: seconds &+ nanoseconds)
    }

    #if !os(WASI)
    @inlinable
    static func duration(from value: timeval) -> CompactDuration {
        /// This can overflow for year 2262, or if the number is too big and reports
        /// something else (for example imagine cumulative CPU time of lots of CPU cores).
        /// Therefore we won't do unchecked arithmetic here just to be safe.
        let seconds = Int64(value.tv_sec) * 1_000_000_000
        let microseconds = Int64(value.tv_usec) * 1_000
        /// Checked math here is unnecessary because `seconds` calc would overflow first anyway.
        return CompactDuration(nanoseconds: seconds &+ microseconds)
    }

    @inlinable
    static func readResourceUsage(
        of selector: Int32
    ) -> (user: CompactDuration, system: CompactDuration)? {
        var usage = rusage()
        guard unsafe csystem_clock_getrusage(selector, &usage) == 0 else {
            return nil
        }
        return (Self.duration(from: usage.ru_utime), Self.duration(from: usage.ru_stime))
    }
    #endif
}

@available(*, unavailable)
extension POSIX: Sendable {}

#endif
