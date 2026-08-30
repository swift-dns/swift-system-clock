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

    @Test(
        arguments: [
            SystemClock<Swift.Duration>.continuous,
            SystemClock<Swift.Duration>.suspending,
            SystemClock<Swift.Duration>.realtime,
        ]
    )
    func `blocking sleep wakes at or after the deadline`(clock: SystemClock<Swift.Duration>) {
        let deadline = clock.now.advanced(by: .milliseconds(50))
        clock._blockingSleep(until: deadline)
        #expect(clock.now >= deadline)
    }

    @Test func `blocking sleep for a duration waits at least that long`() {
        let clock = SystemClock<Swift.Duration>.continuous
        let start = clock.now
        clock._blockingSleep(for: .milliseconds(50))
        #expect(start.duration(to: clock.now) >= .milliseconds(50))
    }

    @Test func `blocking sleep returns at once for a deadline already passed`() {
        let clock = SystemClock<Swift.Duration>.continuous
        clock._blockingSleep(until: clock.now.advanced(by: .seconds(-10)))
    }

    /// `measure` comes from the `Clock` protocol, so this is really a check that the
    /// conformance is wired up.
    @Test func `measure reports the time the work took`() {
        let clock = SystemClock<Swift.Duration>.continuous
        let measured = clock.measure {
            SystemClock<Swift.Duration>.continuous._blockingSleep(for: .milliseconds(20))
        }
        #expect(measured >= .milliseconds(20))
        #expect(measured < .seconds(5))
    }
}
