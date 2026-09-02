#if $Embedded

// Embedded Swift has no ``GenericSystemClock``, so nothing here is ever reached. It fills the platform
// slot on targets that have no clock at all, which is what lets ``GenericSystemClock`` keep being
// declared, and so keep saying it is unavailable, rather than not being found.
@usableFromInline
struct UnavailableClock: Sendable {
    @inlinable
    init() {}

    @inlinable
    func read() -> CompactDuration? {
        nil
    }

    @inlinable
    func resolution() -> CompactDuration? {
        nil
    }
}

#endif
