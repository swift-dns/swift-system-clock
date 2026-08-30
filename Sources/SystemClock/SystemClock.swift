/// A Swift `Clock` corresponding to an OS clock.
///
/// The initializer names every platform Swift supports, and keeps only the id belonging to the
/// platform it is compiled for. The other arguments are discarded at compile time.
///
/// ```swift
/// let clock = SystemClock(
///     darwin: .uptimeRaw,
///     linux: .monotonic,
///     windows: .unbiasedInterruptTimePrecise,
///     freebsd: .uptime,
///     openbsd: .uptime,
///     wasi: .monotonic
/// )
/// ```
@available(SwiftStdlib 5.7, *)
public struct SystemClock<SCDuration>: Sendable {

    /// The clock of the platform being compiled for, holding the id in whichever form that
    /// platform takes.
    @usableFromInline
    let clock: PlatformClock

    @inlinable
    init(clock: PlatformClock) {
        self.clock = clock
    }

    /// Creates a clock from the id belonging to the platform being compiled for.
    ///
    /// Android takes `linux`, and every Apple platform takes `darwin`.
    @inlinable
    public init(
        darwin: DarwinClockID,
        linux: LinuxClockID,
        windows: WindowsClockID,
        freebsd: FreeBSDClockID,
        openbsd: OpenBSDClockID,
        wasi: WASIClockID
    ) {
        #if canImport(Darwin)
        self.init(clock: DarwinClock(id: darwin))
        #elseif os(Linux) || os(Android)
        self.init(clock: POSIXClock(id: linux.rawValue))
        #elseif os(Windows)
        self.init(clock: WindowsClock(id: windows))
        #elseif os(FreeBSD)
        self.init(clock: POSIXClock(id: freebsd.rawValue))
        #elseif os(OpenBSD)
        self.init(clock: POSIXClock(id: openbsd.rawValue))
        #elseif os(WASI)
        self.init(clock: WASIClock(id: wasi))
        #else
        #error("The SystemClock module does not know which clock ids your platform uses.")
        #endif
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock: Clock where SCDuration: SystemDurationProtocol {
    public typealias Duration = SCDuration

    /// The current instant.
    @inlinable
    public var now: Instant {
        guard let reading = self.clock.read() else {
            _clockIDRejected(self.clock.rawID)
        }
        return Instant(_value: .nanoseconds(reading.nanoseconds))
    }

    /// The smallest non-zero difference the clock reports between two instants.
    ///
    /// This is a lower bound on resolution rather than a measurement of how precise the
    /// underlying hardware is.
    @inlinable
    public var minimumResolution: Self.Duration {
        guard let reading = self.clock.resolution() else {
            _clockIDRejected(self.clock.rawID)
        }
        return Self.Duration.nanoseconds(reading.nanoseconds)
    }
}

/// Outlined, and off the hot path, so that reading a clock stays a call and a compare.
@inline(never)
@usableFromInline
func _clockIDRejected(_ id: Int32) -> Never {
    fatalError("SystemClock: the operating system rejected clock id '\(id)'")
}
