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
///     wasi: .monotonic,
///     fallback: .monotonic
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
///     wasi: .monotonic,
///     fallback: .monotonic
/// )
/// ```
@available(SwiftStdlib 5.7, *)
@_unavailableInEmbedded
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
        .stdChrono(self.clock.id)
        #endif
    }
    #endif

    /// Creates a clock from the id belonging to the platform being compiled for.
    ///
    /// Android takes `linux`, and every Apple platform takes `darwin`.
    /// A platform this library has no ids for takes `fallback`, which uses `std::chrono` clocks.
    @inlinable
    public init(
        darwin: DarwinClockID,
        linux: LinuxClockID,
        windows: WindowsClockID,
        freebsd: FreeBSDClockID,
        openbsd: OpenBSDClockID,
        wasi: WASIClockID,
        fallback: STDChronoClockID
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
        self.clock = STDChronoClock(id: fallback)
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
    ///
    /// Traps if the operating system rejects the clock's id, or reports a time outside the ±292
    /// years that 64 bits of nanoseconds hold.
    @inlinable
    public var now: Instant {
        guard let reading = self.clock.read() else {
            fatalError(
                "SystemClock: the operating system rejected the clock's id or its reading, or reported a time outside ±292 years"
            )
        }
        return Instant(_value: .nanoseconds(reading.nanoseconds))
    }

    /// The resolution the platform reports for the clock, or a fixed estimate.
    ///
    /// This is `clock_getres` where the platform has a clock id for the clock, the runtime's
    /// `clock_res_get` on WASI, the `period` of the `std::chrono` type on the fallback, and a fixed
    /// estimate for the clocks that use `getrusage`/`thread_info` or Windows tick clocks.
    ///
    /// It is neither a measurement nor a bound: the reported value can exceed the step the clock
    /// actually takes, as with the Windows tick clocks, FreeBSD's `virtual` and `prof`, OpenBSD's
    /// cpu-time clocks and wasmtime's `monotonic`, or fall short of it, as with cached clocks.
    /// For measurements, see the "Step granularity" row of each clock's table.
    @inlinable
    public var minimumResolution: Duration {
        guard let reading = self.clock.resolution() else {
            fatalError(
                "SystemClock: the operating system rejected the clock's id or its resolution, or reported a resolution outside ±292 years."
            )
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
