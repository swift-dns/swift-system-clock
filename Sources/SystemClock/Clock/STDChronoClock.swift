#if !$Embedded

public import CSystemClock

/// Relies on `std::chrono` clocks to answer clock ids.
@usableFromInline
struct STDChronoClock: Sendable {
    @usableFromInline
    let id: STDChronoClockID

    @inlinable
    init(id: STDChronoClockID) {
        self.id = id
    }

    @inlinable
    @inline(always)
    func read() -> CompactDuration? {
        var value: Int64 = 0
        guard unsafe csystem_clock_std_chrono_gettime(self.id.rawValue, &value) == 0 else {
            return nil
        }
        return CompactDuration(nanoseconds: value)
    }

    @inlinable
    @inline(always)
    func resolution() -> CompactDuration? {
        var value: Int64 = 0
        guard unsafe csystem_clock_std_chrono_getres(self.id.rawValue, &value) == 0 else {
            return nil
        }
        return CompactDuration(nanoseconds: value)
    }
}

#endif
