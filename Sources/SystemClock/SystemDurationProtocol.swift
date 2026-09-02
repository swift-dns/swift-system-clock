@available(SwiftStdlib 5.7, *)
public protocol SystemDurationProtocol: DurationProtocol & Hashable {
    var nanoseconds: Int64 { get }

    static func nanoseconds(_ nanoseconds: Int64) -> Self
}
