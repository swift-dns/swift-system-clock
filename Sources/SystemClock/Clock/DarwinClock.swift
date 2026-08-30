#if canImport(Darwin)

public import Darwin

/// The Darwin end of ``PlatformClock``.
///
/// `clock_gettime_nsec_np(3)` answers whole nanoseconds, so a reading needs no division and no
/// `timespec`. Darwin has no `clock_nanosleep(2)`, so a deadline is waited out as a relative
/// wait like any other.
@usableFromInline
struct DarwinClock: Sendable {
    @usableFromInline
    let id: clockid_t

    @inlinable
    init(id: DarwinClockID) {
        self.id = clockid_t(rawValue: UInt32(bitPattern: id.rawValue))
    }

    @inlinable
    var rawID: Int32 {
        Int32(bitPattern: self.id.rawValue)
    }

    /// Zero marks a refused id, which is what `clock_gettime_nsec_np(3)` answers for one, and
    /// which no live clock reads.
    @inlinable
    func read() -> CompactDuration? {
        let nanoseconds = clock_gettime_nsec_np(self.id)
        if nanoseconds == 0 {
            return nil
        }
        return CompactDuration(nanoseconds: Int64(nanoseconds))
    }

    @inlinable
    func resolution() -> CompactDuration? {
        var value = timespec()
        guard unsafe clock_getres(self.id, &value) == 0 else {
            return nil
        }
        return CompactDuration(value)
    }

    @inlinable
    func sleep(until deadline: CompactDuration, orFor remaining: CompactDuration) {
        posixSleep(for: remaining)
    }
}

#endif
