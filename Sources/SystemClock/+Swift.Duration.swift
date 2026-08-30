@available(SwiftStdlib 5.7, *)
extension Swift.Duration: SystemDurationProtocol {
    @inlinable
    public var nanoseconds: Int64 {
        let components = self.components
        let (scaled, scaleOverflowed) = components.seconds.multipliedReportingOverflow(
            by: 1_000_000_000
        )
        if !scaleOverflowed {
            let (total, addOverflowed) = scaled.addingReportingOverflow(
                components.attoseconds / 1_000_000_000
            )
            if !addOverflowed {
                return total
            }
        }
        return components.seconds < 0 ? .min : .max
    }
}
