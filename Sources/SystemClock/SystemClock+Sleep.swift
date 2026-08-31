@available(SwiftStdlib 5.7, *)
extension SystemClock where Self: Clock {
    /// Suspends until this clock reaches `deadline`, or throws `CancellationError` if the task
    /// is cancelled first.
    ///
    /// TODO: Don't block the thread.
    /// TODO: Cancellation support.
    public func sleep(until deadline: Instant, tolerance: Duration? = nil) async throws {
        self._blockingSleep(until: deadline)
    }

    /// Blocks the calling thread until this clock reaches `deadline`.
    ///
    /// Never call this in a structured-concurrency context as it prevents forward-progress.
    ///
    /// Waking is guaranteed to happen at or after `duration`, never before.
    public func _blockingSleep(until deadline: Instant) {
        precondition(
            deadline._value.nanoseconds >= 0,
            "SystemClock: cannot sleep for a negative duration"
        )
        while true {
            let remaining = self.now.duration(to: deadline)
            if remaining <= .zero {
                return
            }
            self.clock.sleep(
                until: CompactDuration(nanoseconds: deadline._value.nanoseconds),
                orFor: CompactDuration(nanoseconds: remaining.nanoseconds)
            )
        }
    }

    /// Blocks the calling thread for `duration`, measured on this clock.
    ///
    /// Never call this in a structured-concurrency context as it prevents forward-progress.
    ///
    /// Waking is guaranteed to happen at or after `duration`, never before.
    public func _blockingSleep(for duration: Duration) {
        precondition(duration.nanoseconds >= 0, "SystemClock: cannot sleep for a negative duration")
        self._blockingSleep(until: self.now.advanced(by: duration))
    }
}
