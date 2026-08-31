#if !os(Windows)

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

public import CSystemClock

/// The conversions and the wait that every `clock_gettime(2)` platform shares, which is every
/// one Swift supports bar Windows.
@usableFromInline
enum POSIX {
    @inlinable
    static func duration(from value: timespec) -> CompactDuration {
        let seconds = Int64(value.tv_sec) * 1_000_000_000
        let nanoseconds = Int64(value.tv_nsec)
        return CompactDuration(nanoseconds: seconds + nanoseconds)
    }

    @inlinable
    static func clampedTimespec(from duration: CompactDuration) -> timespec {
        let isNegative = duration.nanoseconds <= 0
        let tv_sec = isNegative ? 0 : duration.nanoseconds / 1_000_000_000
        let tv_nsec = isNegative ? 0 : duration.nanoseconds % 1_000_000_000
        return timespec(tv_sec: .init(tv_sec), tv_nsec: .init(tv_nsec))
    }

    @inlinable
    static func sleep(for duration: CompactDuration) {
        var request = Self.clampedTimespec(from: duration)
        var leftover = timespec()
        while unsafe nanosleep(&request, &leftover) == -1 && errno == EINTR {
            request = leftover
        }
    }

    #if !os(WASI)
    @inlinable
    static func duration(from value: timeval) -> CompactDuration {
        let seconds = Int64(value.tv_sec) * 1_000_000_000
        let microseconds = Int64(value.tv_usec) * 1_000
        return CompactDuration(nanoseconds: seconds + microseconds)
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
