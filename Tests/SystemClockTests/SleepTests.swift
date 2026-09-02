#if os(macOS) || os(Linux) || os(FreeBSD) || os(OpenBSD) || os(Windows)

import SystemClock
import Testing

@Suite
struct SleepTests {
    @Test func `sleeping through the standard library clock protocol traps`() async {
        await #expect(processExitsWith: .failure) {
            let clock = GenericSystemClock<Swift.Duration>.continuous
            try await Task.sleep(for: .milliseconds(1), clock: clock)
        }
    }

    @available(*, deprecated)
    @Test func `sleeping on a system clock traps`() async {
        await #expect(processExitsWith: .failure) {
            let clock = GenericSystemClock<Swift.Duration>.continuous
            try await clock.sleep(until: clock.now)
        }
    }
}

#endif
