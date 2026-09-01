import Foundation
import SystemClock
import Testing

@Suite
struct InstantTests {
    @Test func `advancing and measuring are inverses`() {
        let start = GenericSystemClock<Swift.Duration>.Instant.epoch.advanced(by: .seconds(10))
        let end = start.advanced(by: .milliseconds(1_500))
        #expect(start.duration(to: end) == .milliseconds(1_500))
        #expect(end.duration(to: start) == .milliseconds(-1_500))
    }

    @Test func `advancing backwards works`() {
        let start = GenericSystemClock<Swift.Duration>.Instant.epoch.advanced(by: .seconds(10))
        #expect(start.advanced(by: .seconds(-10)) == .epoch)
    }

    @Test func `operators agree with the methods`() {
        let start = GenericSystemClock<Swift.Duration>.Instant.epoch.advanced(by: .seconds(3))
        #expect(start + .seconds(2) == start.advanced(by: .seconds(2)))
        #expect(start - .seconds(2) == start.advanced(by: .seconds(-2)))
        #expect((start + .seconds(2)) - start == .seconds(2))

        var mutated = start
        mutated += .seconds(2)
        #expect(mutated == start + .seconds(2))
        mutated -= .seconds(2)
        #expect(mutated == start)
    }

    @Test func `ordering follows the reading`() {
        let earlier = GenericSystemClock<Swift.Duration>.Instant.epoch
        let later = earlier.advanced(by: .nanoseconds(1))
        #expect(earlier < later)
        #expect(later > earlier)
        #expect(earlier != later)
        #expect(earlier == GenericSystemClock<Swift.Duration>.Instant.epoch)
    }

    @Test func `equal instants hash equally`() {
        let first = GenericSystemClock<Swift.Duration>.Instant.epoch.advanced(by: .seconds(7))
        let second = GenericSystemClock<Swift.Duration>.Instant.epoch.advanced(by: .seconds(7))
        #expect(Set([first, second]).count == 1)
    }

    @Test func `an instant round-trips through Codable`() throws {
        let original = GenericSystemClock<Swift.Duration>.Instant.epoch.advanced(
            by: .milliseconds(1_234_567)
        )
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(
            GenericSystemClock<Swift.Duration>.Instant.self,
            from: encoded
        )
        #expect(decoded == original)
    }

    /// A wall-clock instant is far past what 64 bits of nanoseconds would hold once it is
    /// scaled to attoseconds, so this pins down that nothing on the way in truncates it.
    @Test func `a realtime reading keeps its full range`() {
        let reading = GenericSystemClock<Swift.Duration>.realtime.now
        let components = GenericSystemClock<Swift.Duration>.Instant.epoch.duration(to: reading)
            .components
        #expect(components.seconds > 1_735_689_600)
        #expect(components.attoseconds >= 0)
        #expect(components.attoseconds < 1_000_000_000_000_000_000)
    }
}
