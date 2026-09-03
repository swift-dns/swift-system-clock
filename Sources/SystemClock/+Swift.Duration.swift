@available(SwiftStdlib 5.7, *)
extension Swift.Duration: SystemDurationProtocol {
    /// The duration as a count of nanoseconds, with the attoseconds below a nanosecond dropped.
    ///
    /// Traps for a duration outside ±292 years, which is what 64 bits of nanoseconds hold.
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
        fatalError("SystemClock: the duration does not fit in 64 bits of nanoseconds")
    }
}
