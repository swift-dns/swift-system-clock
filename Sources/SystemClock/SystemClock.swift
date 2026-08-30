public import CSystemClock

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
public struct SystemClock: Sendable {
    /// The id handed to the operating system, in whichever form the host platform takes.
    @usableFromInline
    let clockID: Int32

    @inlinable
    init(clockID: Int32) {
        self.clockID = clockID
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
        self.init(clockID: darwin.rawValue)
        #elseif os(Linux) || os(Android)
        self.init(clockID: linux.rawValue)
        #elseif os(Windows)
        self.init(clockID: windows.rawValue)
        #elseif os(FreeBSD)
        self.init(clockID: freebsd.rawValue)
        #elseif os(OpenBSD)
        self.init(clockID: openbsd.rawValue)
        #elseif os(WASI)
        self.init(clockID: wasi.rawValue)
        #else
        #error("The SystemClock module does not know which clock ids your platform uses.")
        #endif
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock: Clock {
    public typealias Duration = Swift.Duration

    /// The current instant.
    @inlinable
    public var now: Instant {
        let reading = csystem_clock_read(self.clockID)
        if reading.isFailure {
            fatalError("SystemClock: the operating system rejected clock id '\(self.clockID)'")
        }
        return Instant(_value: reading.duration)
    }

    /// The smallest non-zero difference the clock reports between two instants.
    ///
    /// This is a lower bound on resolution rather than a measurement of how precise the
    /// underlying hardware is.
    @inlinable
    public var minimumResolution: Duration {
        let reading = csystem_clock_resolution(self.clockID)
        if reading.isFailure {
            fatalError("SystemClock: the operating system rejected clock id '\(self.clockID)'")
        }
        return reading.duration
    }
}
