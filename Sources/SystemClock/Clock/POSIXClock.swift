#if os(Linux) || os(Android) || os(FreeBSD) || os(OpenBSD)

#if canImport(Glibc)
public import Glibc
#elseif canImport(Musl)
public import Musl
#elseif canImport(Android)
public import Android
#else
#error("The SystemClock module was unable to identify your C library.")
#endif

/// The end of ``PlatformClock`` for the platforms that reach their clocks through
/// `clock_gettime(2)`, which is every one Swift supports bar Darwin, Windows and WASI.
///
/// The id is the platform's own `clockid_t`, so which ids are legal is a property of the
/// platform rather than of this type.
@usableFromInline
struct POSIXClock: Sendable {
    @usableFromInline
    let id: Int32

    @inlinable
    init(id: Int32) {
        self.id = id
    }

    @inlinable
    var rawID: Int32 {
        self.id
    }

    @inlinable
    func read() -> CompactDuration? {
        var value = timespec()
        guard unsafe clock_gettime(clockid_t(self.id), &value) == 0 else {
            return nil
        }
        return CompactDuration(value)
    }

    @inlinable
    func resolution() -> CompactDuration? {
        var value = timespec()
        guard unsafe clock_getres(clockid_t(self.id), &value) == 0 else {
            return nil
        }
        return CompactDuration(value)
    }

    /// The kernel waits on only some of its clocks and refuses the rest, which is what the
    /// relative wait is there to catch.
    @inlinable
    func sleep(until deadline: CompactDuration, orFor remaining: CompactDuration) {
        var target = timespec(clamping: deadline)
        let status = unsafe clock_nanosleep(clockid_t(self.id), TIMER_ABSTIME, &target, nil)
        if status != EINVAL && status != ENOTSUP && status != EOPNOTSUPP {
            return
        }
        posixSleep(for: remaining)
    }
}

#endif
