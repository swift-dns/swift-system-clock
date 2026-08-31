import SystemClock
import Testing

@Suite
struct SleepTests {
    @Test(
        arguments: [
            SystemClock<Swift.Duration>.continuous,
            SystemClock<Swift.Duration>.suspending,
            SystemClock<Swift.Duration>.realtime,
        ]
    )
    func `sleeping wakes at or after the deadline`(clock: SystemClock<Swift.Duration>) async throws
    {
        let deadline = clock.now.advanced(by: .milliseconds(50))
        try await clock.sleep(until: deadline)
        #expect(clock.now >= deadline)
    }

    @Test func `sleeping returns at once for a deadline already passed`() async throws {
        let clock = SystemClock<Swift.Duration>.continuous
        try await clock.sleep(until: clock.now.advanced(by: .seconds(-10)))
    }

    /// `SystemClock.sleep(until:tolerance:)` blocks and never looks at cancellation. Enable
    /// this once the `TODO: Cancellation support.` in `SystemClock+Sleep.swift` is done.
    @Test(.disabled("SystemClock.sleep does not support cancellation yet"))
    func `sleeping is cancellable`() async throws {
        let clock = SystemClock<Swift.Duration>.continuous
        let task = Task {
            try await clock.sleep(until: clock.now.advanced(by: .seconds(30)))
        }
        task.cancel()
        await #expect(throws: CancellationError.self) {
            try await task.value
        }
    }
}
