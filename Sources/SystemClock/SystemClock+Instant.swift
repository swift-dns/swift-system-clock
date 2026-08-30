@available(SwiftStdlib 5.7, *)
extension SystemClock {
    /// A point in time.
    ///
    /// ```swift
    /// let start: SystemClock.Instant = SystemClock.suspending.now
    /// doWork()
    /// let elapsed: SystemClock.Duration = start.duration(to: SystemClock.suspending.now)
    /// ```
    public struct Instant {
        @usableFromInline
        var _value: SCDuration

        @inlinable
        init(_value: SCDuration) {
            self._value = _value
        }
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: InstantProtocol where SCDuration: SystemDurationProtocol {
    /// The instant whose reading is zero, which is the clock's own epoch.
    @inlinable
    public static var epoch: Self {
        Self(_value: .zero)
    }

    @inlinable
    public func duration(to other: Self) -> SCDuration {
        other._value - self._value
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: Sendable where SCDuration: Sendable {}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: Equatable where SCDuration: Equatable {
    @inlinable
    public static func == (lhs: SystemClock.Instant, rhs: SystemClock.Instant) -> Bool {
        lhs._value == rhs._value
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: Hashable where SCDuration: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self._value)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: Comparable where SCDuration: Comparable {
    @inlinable
    public static func < (lhs: SystemClock.Instant, rhs: SystemClock.Instant) -> Bool {
        lhs._value < rhs._value
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: Encodable where SCDuration: Encodable {
    @inlinable
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self._value)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant: Decodable where SCDuration: Decodable {
    @inlinable
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self._value = try container.decode(SCDuration.self)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant where SCDuration: AdditiveArithmetic {
    @inlinable
    public func advanced(by duration: SCDuration) -> Self {
        Self(_value: self._value + duration)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock.Instant where SCDuration: AdditiveArithmetic {
    @inlinable
    public static func + (lhs: SystemClock.Instant, rhs: SCDuration) -> SystemClock.Instant {
        lhs.advanced(by: rhs)
    }

    @inlinable
    public static func += (lhs: inout SystemClock.Instant, rhs: SCDuration) {
        lhs = lhs.advanced(by: rhs)
    }

    @inlinable
    public static func - (lhs: SystemClock.Instant, rhs: SCDuration) -> SystemClock.Instant {
        lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func -= (lhs: inout SystemClock.Instant, rhs: SCDuration) {
        lhs = lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func - (lhs: SystemClock.Instant, rhs: SystemClock.Instant) -> SCDuration {
        lhs.advanced(by: .zero - rhs._value)._value
    }
}
