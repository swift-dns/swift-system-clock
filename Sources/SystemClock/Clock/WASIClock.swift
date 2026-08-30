#if os(WASI)

public import WASILibc
internal import CSystemClock

/// The WASI end of ``PlatformClock``.
///
/// wasi-libc spells `CLOCK_REALTIME` and `CLOCK_MONOTONIC` as the addresses of extern objects
/// rather than as integers, so there is no number for Swift to import and the id is turned back
/// into a `clockid_t` by `CSystemClock`. WASI has no `clock_nanosleep(2)`.
@usableFromInline
struct WASIClock: Sendable {
    @usableFromInline
    let id: WASIClockID

    @inlinable
    init(id: WASIClockID) {
        self.id = id
    }

    @inlinable
    var rawID: Int32 {
        self.id.rawValue
    }

    @inlinable
    func read() -> CompactDuration? {
        var value = timespec()
        guard let clock = self.platformID,
            unsafe clock_gettime(clock, &value) == 0
        else {
            return nil
        }
        return CompactDuration(value)
    }

    @inlinable
    func resolution() -> CompactDuration? {
        var value = timespec()
        guard let clock = self.platformID,
            unsafe clock_getres(clock, &value) == 0
        else {
            return nil
        }
        return CompactDuration(value)
    }

    @inlinable
    func sleep(until deadline: CompactDuration, orFor remaining: CompactDuration) {
        posixSleep(for: remaining)
    }

    @inlinable
    var platformID: clockid_t? {
        var clock: clockid_t?
        guard unsafe csystem_clock_wasi_clockid(self.id.rawValue, &clock) == 0 else {
            return nil
        }
        return clock
    }
}

#endif
