/// A representation of nanosecond-precision time.
///
/// Typical construction of `CompactDuration` values should be created via the
/// static methods for specific time values.
///
/// ```swift
/// var d: CompactDuration = .seconds(3)
/// d += .milliseconds(33)
/// print(d) // 3.033 seconds
/// ```
///
/// `CompactDuration` itself does not ferry any additional information other than the
/// temporal measurement component; specifically leap seconds should be
/// represented as an additional accessor since that is specific only to certain
/// clock implementations.
public struct CompactDuration: Sendable {
    /// The number of nanoseconds represented by this `CompactDuration`.
    public var nanoseconds: Int64

    @inlinable
    public init(nanoseconds: Int64) {
        self.nanoseconds = nanoseconds
    }

    /// Construct a `CompactDuration` given a duration and scale, taking care so that
    /// exact integer durations are preserved exactly.
    internal init(_ duration: Double, scale: Int64) {
        // Split the duration into integral and fractional parts, as we need to
        // handle them slightly differently to ensure that integer values are
        // never rounded if `scale` is representable as Double.
        let integralPart = duration.rounded(.towardZero)
        let fractionalPart = duration - integralPart
        self.init(
            nanoseconds:
                // This term may trap due to overflow, but it cannot round, so if the
                // input `seconds` is an exact integer, we get an exact integer result.
                Int64(integralPart) * scale
                // This term may round, but cannot overflow.
                + Int64((fractionalPart * Double(scale)).rounded())
        )
    }
}

@available(SwiftStdlib 5.7, *)
extension CompactDuration {
    /// Construct a `CompactDuration` given a number of seconds represented as a
    /// `BinaryInteger`.
    ///
    /// ```swift
    /// let d: CompactDuration = .seconds(77)
    /// ```
    ///
    /// - Returns: A `CompactDuration` representing a given number of seconds.
    @inlinable
    public static func seconds<T: BinaryInteger>(_ seconds: T) -> CompactDuration {
        CompactDuration(nanoseconds: Int64(seconds) * 1_000_000_000)
    }

    /// Construct a `CompactDuration` given a number of seconds represented as a
    /// `Double` by converting the value into the closest nanosecond scale value.
    ///
    /// ```swift
    /// let d: CompactDuration = .seconds(22.93)
    /// ```
    ///
    /// - Returns: A `CompactDuration` representing a given number of seconds.
    public static func seconds(_ seconds: Double) -> CompactDuration {
        CompactDuration(seconds, scale: 1_000_000_000)
    }

    /// Construct a `CompactDuration` given a number of milliseconds represented as a
    /// `BinaryInteger`.
    ///
    ///       let d: CompactDuration = .milliseconds(645)
    ///
    /// - Returns: A `CompactDuration` representing a given number of milliseconds.
    @inlinable
    public static func milliseconds<T: BinaryInteger>(_ milliseconds: T) -> CompactDuration {
        CompactDuration(nanoseconds: Int64(milliseconds) * 1_000_000)
    }

    /// Construct a `CompactDuration` given a number of seconds milliseconds as a
    /// `Double` by converting the value into the closest nanosecond scale value.
    ///
    /// ```swift
    /// let d: CompactDuration = .milliseconds(88.3)
    /// ```
    ///
    /// - Returns: A `CompactDuration` representing a given number of milliseconds.
    public static func milliseconds(_ milliseconds: Double) -> CompactDuration {
        CompactDuration(milliseconds, scale: 1_000_000)
    }

    /// Construct a `CompactDuration` given a number of microseconds represented as a
    /// `BinaryInteger`.
    ///
    /// ```swift
    /// let d: CompactDuration = .microseconds(12)
    /// ```
    ///
    /// - Returns: A `CompactDuration` representing a given number of microseconds.
    @inlinable
    public static func microseconds<T: BinaryInteger>(_ microseconds: T) -> CompactDuration {
        CompactDuration(nanoseconds: Int64(microseconds) * 1_000)
    }

    /// Construct a `CompactDuration` given a number of seconds microseconds as a
    /// `Double` by converting the value into the closest nanosecond scale value.
    ///
    /// ```swift
    /// let d: CompactDuration = .microseconds(382.9)
    /// ```
    ///
    /// - Returns: A `CompactDuration` representing a given number of microseconds.
    public static func microseconds(_ microseconds: Double) -> CompactDuration {
        CompactDuration(microseconds, scale: 1_000)
    }

    /// Construct a `CompactDuration` given a number of nanoseconds represented as a
    /// `BinaryInteger`.
    ///
    /// ```swift
    /// let d: CompactDuration = .nanoseconds(1929)
    /// ```
    ///
    /// - Returns: A `CompactDuration` representing a given number of nanoseconds.
    @inlinable
    public static func nanoseconds<T: BinaryInteger>(_ nanoseconds: T) -> CompactDuration {
        CompactDuration(nanoseconds: Int64(nanoseconds))
    }

    /// Construct a `CompactDuration` given a number of nanoseconds as a
    /// `Double` by converting the value into the closest nanosecond scale value.
    ///
    /// ```swift
    /// let d: CompactDuration = .nanoseconds(382.9)
    /// ```
    ///
    /// - Returns: A `CompactDuration` representing a given number of nanoseconds.
    @available(SwiftStdlib 6.2, *)
    public static func nanoseconds(_ nanoseconds: Double) -> CompactDuration {
        CompactDuration(nanoseconds, scale: 1)
    }
}

#if !$Embedded
extension CompactDuration: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let nanoseconds = try container.decode(Int64.self)
        self.init(nanoseconds: nanoseconds)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(nanoseconds)
    }
}
#endif

@available(SwiftStdlib 5.7, *)
extension CompactDuration: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(nanoseconds)
    }
}

@available(SwiftStdlib 5.7, *)
extension CompactDuration: Equatable {
    public static func == (_ lhs: CompactDuration, _ rhs: CompactDuration) -> Bool {
        lhs.nanoseconds == rhs.nanoseconds
    }
}

@available(SwiftStdlib 5.7, *)
extension CompactDuration: Comparable {
    public static func < (_ lhs: CompactDuration, _ rhs: CompactDuration) -> Bool {
        lhs.nanoseconds < rhs.nanoseconds
    }
}

@available(SwiftStdlib 5.7, *)
extension CompactDuration: AdditiveArithmetic {
    public static var zero: CompactDuration { CompactDuration(nanoseconds: 0) }

    public static func + (_ lhs: CompactDuration, _ rhs: CompactDuration) -> CompactDuration {
        CompactDuration(nanoseconds: lhs.nanoseconds + rhs.nanoseconds)
    }

    public static func - (_ lhs: CompactDuration, _ rhs: CompactDuration) -> CompactDuration {
        CompactDuration(nanoseconds: lhs.nanoseconds - rhs.nanoseconds)
    }

    public static func += (_ lhs: inout CompactDuration, _ rhs: CompactDuration) {
        lhs = lhs + rhs
    }

    public static func -= (_ lhs: inout CompactDuration, _ rhs: CompactDuration) {
        lhs = lhs - rhs
    }
}

@available(SwiftStdlib 5.7, *)
extension CompactDuration {
    public static func / (_ lhs: CompactDuration, _ rhs: Double) -> CompactDuration {
        CompactDuration(nanoseconds: Int64(Double(lhs.nanoseconds) / rhs))
    }

    public static func /= (_ lhs: inout CompactDuration, _ rhs: Double) {
        lhs = lhs / rhs
    }

    public static func / <T: BinaryInteger>(
        _ lhs: CompactDuration,
        _ rhs: T
    ) -> CompactDuration {
        CompactDuration(nanoseconds: lhs.nanoseconds / Int64(rhs))
    }

    public static func /= <T: BinaryInteger>(_ lhs: inout CompactDuration, _ rhs: T) {
        lhs = lhs / rhs
    }

    public static func / (_ lhs: CompactDuration, _ rhs: CompactDuration) -> Double {
        Double(lhs.nanoseconds) / Double(rhs.nanoseconds)
    }

    public static func * (_ lhs: CompactDuration, _ rhs: Double) -> CompactDuration {
        CompactDuration(nanoseconds: Int64(Double(lhs.nanoseconds) * rhs))
    }

    public static func * <T: BinaryInteger>(
        _ lhs: CompactDuration,
        _ rhs: T
    ) -> CompactDuration {
        CompactDuration(nanoseconds: lhs.nanoseconds * Int64(rhs))
    }

    public static func *= <T: BinaryInteger>(_ lhs: inout CompactDuration, _ rhs: T) {
        lhs = lhs * rhs
    }
}

@_unavailableInEmbedded
extension CompactDuration: CustomStringConvertible {
    public var description: String {
        (Double(nanoseconds) / 1e9).description + " seconds"
    }
}

@available(SwiftStdlib 5.7, *)
extension CompactDuration: DurationProtocol {}

@available(SwiftStdlib 5.7, *)
extension CompactDuration: SystemDurationProtocol {}
