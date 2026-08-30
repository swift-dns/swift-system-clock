@available(SwiftStdlib 5.7, *)
extension SystemClock {
    /// A point in time.
    ///
    /// ```swift
    /// let start: SystemClock.Instant = SystemClock.suspending.now
    /// doWork()
    /// let elapsed: SystemClock.Duration = start.duration(to: SystemClock.suspending.now)
    /// ```
    public struct Instant: Sendable, Codable {
        @usableFromInline
        var _value: Swift.Duration

        @inlinable
        init(_value: Swift.Duration) {
            self._value = _value
        }
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: InstantProtocol {
    public typealias Duration = Swift.Duration

    /// The instant whose reading is zero, which is the clock's own epoch.
    @inlinable
    public static var epoch: SystemClock.Instant {
        SystemClock.Instant(_value: .zero)
    }

    @inlinable
    public func advanced(by duration: Duration) -> SystemClock.Instant {
        SystemClock.Instant(_value: self._value + duration)
    }

    @inlinable
    public func duration(to other: SystemClock.Instant) -> Duration {
        other._value - self._value
    }

    @inlinable
    public static func == (lhs: SystemClock.Instant, rhs: SystemClock.Instant) -> Bool {
        lhs._value == rhs._value
    }

    @inlinable
    public static func < (lhs: SystemClock.Instant, rhs: SystemClock.Instant) -> Bool {
        lhs._value < rhs._value
    }

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self._value)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant {
    @inlinable
    public static func + (lhs: SystemClock.Instant, rhs: Duration) -> SystemClock.Instant {
        lhs.advanced(by: rhs)
    }

    @inlinable
    public static func += (lhs: inout SystemClock.Instant, rhs: Duration) {
        lhs = lhs.advanced(by: rhs)
    }

    @inlinable
    public static func - (lhs: SystemClock.Instant, rhs: Duration) -> SystemClock.Instant {
        lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func -= (lhs: inout SystemClock.Instant, rhs: Duration) {
        lhs = lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func - (lhs: SystemClock.Instant, rhs: SystemClock.Instant) -> Duration {
        rhs.duration(to: lhs)
    }
}
