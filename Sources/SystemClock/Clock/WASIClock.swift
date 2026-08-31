#if os(WASI) && !$Embedded

public import WASILibc
public import CSystemClock

/// The WASI end of ``_PlatformClockTypealias``.
@usableFromInline
struct WASIClock: Sendable {
    @usableFromInline
    let id: WASIClockID

    @inlinable
    var platformID: clockid_t? {
        var clock: clockid_t?
        guard unsafe csystem_clock_wasi_clockid(self.id.rawValue, &clock) == 0 else {
            return nil
        }
        return clock
    }

    @inlinable
    init(id: WASIClockID) {
        self.id = id
    }

    @inlinable
    @inline(always)
    func read() -> CompactDuration? {
        var value = timespec()
        guard let clock = self.platformID,
            unsafe clock_gettime(clock, &value) == 0
        else {
            return nil
        }
        return POSIX.duration(from: value)
    }

    @inlinable
    @inline(always)
    func resolution() -> CompactDuration? {
        var value = timespec()
        guard let clock = self.platformID,
            unsafe clock_getres(clock, &value) == 0
        else {
            return nil
        }
        return POSIX.duration(from: value)
    }

    @inlinable
    @inline(always)
    func sleep(until deadline: CompactDuration, orFor remaining: CompactDuration) {
        POSIX.sleep(for: remaining)
    }
}

#endif
