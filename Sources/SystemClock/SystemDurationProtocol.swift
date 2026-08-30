@available(SwiftStdlib 5.7, *)
public protocol SystemDurationProtocol: DurationProtocol & Hashable {
    static func nanoseconds(_ nanoseconds: Int64) -> Self

    /// Saturating, because a duration wider than `Int64` nanoseconds is one no clock reads and
    /// no wait needs.
    var nanoseconds: Int64 { get }
}
