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
///
/// `SystemClock` is a typealias for `GenericSystemClock<CompactDuration>`.
/// If you desire so, you can use `GenericSystemClock<Swift.Duration>` instead.
/// This is generally not recommended but can be useful in certain cases.
/// `GenericSystemClock<Swift.Duration>` doesn't add noticeable overhead either.
///
/// ```swift
/// let clock = GenericSystemClock<Duration>(
///     darwin: .uptimeRaw,
///     linux: .monotonic,
///     windows: .unbiasedInterruptTimePrecise,
///     freebsd: .uptime,
///     openbsd: .uptime,
///     wasi: .monotonic
/// )
/// ```
@available(SwiftStdlib 5.7, *)
@_unavailableInEmbedded
@_assemblyVision
@_semantics("optremark")
public struct GenericSystemClock<Duration>: Sendable {
    public typealias Instant = SystemInstant<Duration>

    @usableFromInline
    let clock: _PlatformClockTypealias

    #if !$Embedded
    @inlinable
    public var currentClockID: AnySystemClockID {
        #if canImport(Darwin)
        .darwin(DarwinClockID(rawValue: self.clock.swiftyID))
        #elseif os(Linux) || os(Android)
        .linux(LinuxClockID(rawValue: self.clock.id))
        #elseif os(Windows)
        .windows(self.clock.id)
        #elseif os(FreeBSD)
        .freebsd(FreeBSDClockID(rawValue: self.clock.id))
        #elseif os(OpenBSD)
        .openbsd(OpenBSDClockID(rawValue: self.clock.id))
        #elseif os(WASI)
        .wasi(self.clock.id)
        #else
        #error("The SystemClock module does not know which clock ids your platform uses.")
        #endif
    }
    #endif

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
        #if $Embedded
        self.clock = UnavailableClock()
        #elseif canImport(Darwin)
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

/// A ``GenericSystemClock`` that reports ``CompactDuration``.
@available(SwiftStdlib 5.7, *)
@_unavailableInEmbedded
public typealias SystemClock = GenericSystemClock<CompactDuration>

@available(SwiftStdlib 5.7, *)
@_unavailableInEmbedded
extension GenericSystemClock where Duration: SystemDurationProtocol {
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
    public var minimumResolution: Duration {
        guard let reading = self.clock.resolution() else {
            fatalError("SystemClock: the operating system rejected the clock's id")
        }
        return Duration.nanoseconds(reading.nanoseconds)
    }
}

#if !$Embedded
@available(SwiftStdlib 5.7, *)
extension GenericSystemClock where Duration: SystemDurationProtocol {
    /// Not supported. Always fatal-errors.
    ///
    /// This only exists because `Clock` requires it.
    /// Sleep on the standard library's `ContinuousClock` or `SuspendingClock` instead.
    @available(
        *,
        deprecated,
        message: """
            SystemClock does not support sleeping so this call always traps.
            Use standard library's `ContinuousClock` or `SuspendingClock` instead for sleeping.
            """
    )
    @inlinable
    public func sleep(until deadline: Instant, tolerance: Duration? = nil) async throws {
        fatalError("SystemClock: sleeping is not supported")
    }
}

@available(SwiftStdlib 5.7, *)
extension GenericSystemClock: Clock where Duration: SystemDurationProtocol {}
#endif
