/// A point in time.
///
/// ```swift
/// /// Start is of type `SystemClock.Instant` == `Instant<CompactDuration>`
/// let start: Instant<CompactDuration> = SystemClock.suspending.now
/// doWork()
/// let elapsed: SystemClock.Duration = start.duration(to: SystemClock.suspending.now)
/// ```
@available(SwiftStdlib 5.7, *)
@_assemblyVision
@_semantics("optremark")
public struct SystemInstant<Duration> {
    @usableFromInline
    var _value: Duration

    @inlinable
    init(_value: Duration) {
        self._value = _value
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemInstant: InstantProtocol where Duration: SystemDurationProtocol {
    /// The instant whose reading is zero, which is the clock's own epoch.
    @inlinable
    public static var epoch: Self {
        Self(_value: .zero)
    }

    @inlinable
    public func duration(to other: Self) -> Duration {
        other._value - self._value
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemInstant: Sendable where Duration: Sendable {}

@available(SwiftStdlib 5.7, *)
extension SystemInstant: Equatable where Duration: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._value == rhs._value
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemInstant: Hashable where Duration: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self._value)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemInstant: Comparable where Duration: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs._value < rhs._value
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemInstant: Encodable where Duration: Encodable {
    @inlinable
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self._value)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemInstant: Decodable where Duration: Decodable {
    @inlinable
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self._value = try container.decode(Duration.self)
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemInstant where Duration: AdditiveArithmetic {
    @inlinable
    public func advanced(by duration: Duration) -> Self {
        Self(_value: self._value + duration)
    }

    @inlinable
    public static func + (lhs: Self, rhs: Duration) -> Self {
        lhs.advanced(by: rhs)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Duration) {
        lhs = lhs.advanced(by: rhs)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Duration) -> Self {
        lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Duration) {
        lhs = lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Duration {
        lhs.advanced(by: .zero - rhs._value)._value
    }
}
