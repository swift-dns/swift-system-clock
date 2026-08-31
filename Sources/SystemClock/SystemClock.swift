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
@_assemblyVision
@_semantics("optremark")
public struct SystemClock<Duration>: Sendable {
    public typealias Instant = SystemInstant<Duration>

    @usableFromInline
    let clock: _PlatformClockTypealias

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
        self.clock = DarwinClock(id: darwin)
        #elseif os(Linux) || os(Android)
        self.clock = POSIXClock(id: linux.rawValue)
        #elseif os(Windows)
        self.clock = WindowsClock(id: windows)
        #elseif os(FreeBSD)
        self.clock = POSIXClock(id: freebsd.rawValue)
        #elseif os(OpenBSD)
        self.clock = POSIXClock(id: openbsd.rawValue)
        #elseif os(WASI)
        self.clock = WASIClock(id: wasi)
        #else
        #error("The SystemClock module does not know which clock ids your platform uses.")
        #endif
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock: Clock where Duration: SystemDurationProtocol {
    /// The current instant.
    @inlinable
    public var now: Instant {
        guard let reading = self.clock.read() else {
            fatalError("SystemClock: the operating system rejected the clock's id")
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
            fatalError("SystemClock: the operating system rejected the clock's id")
        }
        return Self.Duration.nanoseconds(reading.nanoseconds)
    }
}

/// Specialized implementations for `CompactDuration`.
@available(SwiftStdlib 5.7, *)
extension SystemClock<CompactDuration> {
    /// The current instant.
    @inlinable
    public var now: Instant {
        guard let reading = self.clock.read() else {
            fatalError("SystemClock: the operating system rejected the clock's id")
        }
        return Instant(_value: reading)
    }

    /// The smallest non-zero difference the clock reports between two instants.
    ///
    /// This is a lower bound on resolution rather than a measurement of how precise the
    /// underlying hardware is.
    @inlinable
    public var minimumResolution: Self.Duration {
        guard let reading = self.clock.resolution() else {
            fatalError("SystemClock: the operating system rejected the clock's id")
        }
        return reading
    }
}

/// Specialized implementations for `Swift.Duration`.
@available(SwiftStdlib 5.7, *)
extension SystemClock<Swift.Duration> {
    /// The current instant.
    @inlinable
    public var now: Instant {
        guard let reading = self.clock.read() else {
            fatalError("SystemClock: the operating system rejected the clock's id")
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
            fatalError("SystemClock: the operating system rejected the clock's id")
        }
        return .nanoseconds(reading.nanoseconds)
    }
}
