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

extension CompactDuration {
    /// A reading, whose remainder the operating system always leaves in `0..<1000000000`.
    @inlinable
    init(_ value: timespec) {
        self.init(nanoseconds: Int64(value.tv_sec) * 1_000_000_000 + Int64(value.tv_nsec))
    }
}

extension timespec {
    /// Clamped to zero: a negative wait is never what a caller means.
    @inlinable
    init(clamping duration: CompactDuration) {
        if duration.nanoseconds <= 0 {
            self.init(tv_sec: 0, tv_nsec: 0)
        } else {
            self.init(
                tv_sec: .init(duration.nanoseconds / 1_000_000_000),
                tv_nsec: .init(duration.nanoseconds % 1_000_000_000)
            )
        }
    }
}

/// Waits out `duration` on whichever clock `nanosleep` happens to use, resuming the remainder
/// after a signal.
@inlinable
func posixSleep(for duration: CompactDuration) {
    var request = timespec(clamping: duration)
    var leftover = timespec()
    while unsafe nanosleep(&request, &leftover) == -1 && errno == EINTR {
        request = leftover
    }
}

#endif
