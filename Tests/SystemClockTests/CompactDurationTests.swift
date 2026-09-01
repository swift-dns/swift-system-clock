import SystemClock
import Testing

@Suite
struct CompactDurationTests {
    @Test func `integer factories scale to nanoseconds`() {
        #expect(CompactDuration.seconds(3).nanoseconds == 3_000_000_000)
        #expect(CompactDuration.milliseconds(645).nanoseconds == 645_000_000)
        #expect(CompactDuration.microseconds(12).nanoseconds == 12_000)
        #expect(CompactDuration.nanoseconds(1929).nanoseconds == 1929)
    }

    @Test func `integer factories carry a sign`() {
        #expect(CompactDuration.seconds(-3).nanoseconds == -3_000_000_000)
        #expect(CompactDuration.milliseconds(-645).nanoseconds == -645_000_000)
        #expect(CompactDuration.microseconds(-12).nanoseconds == -12_000)
        #expect(CompactDuration.nanoseconds(-1929).nanoseconds == -1929)
    }

    @Test func `double factories scale to nanoseconds`() {
        #expect(CompactDuration.seconds(22.93).nanoseconds == 22_930_000_000)
        #expect(CompactDuration.milliseconds(88.3).nanoseconds == 88_300_000)
        #expect(CompactDuration.microseconds(382.9).nanoseconds == 382_900)
    }

    @Test func `double factories carry a sign`() {
        #expect(CompactDuration.seconds(-22.93).nanoseconds == -22_930_000_000)
        #expect(CompactDuration.milliseconds(-88.3).nanoseconds == -88_300_000)
        #expect(CompactDuration.microseconds(-382.9).nanoseconds == -382_900)
    }

    @available(SwiftStdlib 6.2, *)
    @Test func `the double nanosecond factory rounds to the nearest nanosecond`() {
        #expect(CompactDuration.nanoseconds(382.9).nanoseconds == 383)
        #expect(CompactDuration.nanoseconds(382.4).nanoseconds == 382)
        #expect(CompactDuration.nanoseconds(-382.9).nanoseconds == -383)
        #expect(CompactDuration.nanoseconds(1929.0).nanoseconds == 1929)
    }

    @Test func `whole double values stay exact`() {
        #expect(CompactDuration.seconds(22.0) == .seconds(22))
        #expect(CompactDuration.milliseconds(645.0) == .milliseconds(645))
        #expect(CompactDuration.microseconds(12.0) == .microseconds(12))
    }

    /// Each factory is the next one scaled by a thousand, which is what pins down that none of
    /// them reaches for the wrong scale.
    @Test func `the factories are a thousand apart`() {
        #expect(CompactDuration.seconds(1.5) == .milliseconds(1_500.0))
        #expect(CompactDuration.milliseconds(1.5) == .microseconds(1_500.0))
        #expect(CompactDuration.seconds(1) == .milliseconds(1_000))
        #expect(CompactDuration.milliseconds(1) == .microseconds(1_000))
        #expect(CompactDuration.microseconds(1) == .nanoseconds(1_000))
    }

    /// `CompactDuration` is what `SystemClock` reports, so it has to agree with the `Duration`
    /// the standard library would have reported for the same call. A fractional value can land a
    /// nanosecond apart, because `CompactDuration` rounds where `Duration` keeps attoseconds and
    /// this module's `nanoseconds` truncates them.
    @Test func `the integer factories agree with Swift Duration`() {
        #expect(CompactDuration.seconds(7).nanoseconds == Swift.Duration.seconds(7).nanoseconds)
        #expect(
            CompactDuration.milliseconds(645).nanoseconds
                == Swift.Duration.milliseconds(645).nanoseconds
        )
        #expect(
            CompactDuration.microseconds(12).nanoseconds
                == Swift.Duration.microseconds(12).nanoseconds
        )
        #expect(
            CompactDuration.nanoseconds(1929).nanoseconds
                == Swift.Duration.nanoseconds(1929).nanoseconds
        )
    }

    @Test(
        arguments: [
            (CompactDuration.seconds(22.93), Swift.Duration.seconds(22.93)),
            (CompactDuration.milliseconds(88.3), Swift.Duration.milliseconds(88.3)),
            (CompactDuration.microseconds(382.9), Swift.Duration.microseconds(382.9)),
        ]
    )
    func `the double factories land within a nanosecond of Swift Duration`(
        compact: CompactDuration,
        duration: Swift.Duration
    ) {
        let difference = compact.nanoseconds - duration.nanoseconds
        #expect(difference >= -1 && difference <= 1)
    }

    @Test func `arithmetic keeps the nanosecond count`() {
        var duration = CompactDuration.seconds(3)
        duration += .milliseconds(33)
        #expect(duration.nanoseconds == 3_033_000_000)
        duration -= .milliseconds(33)
        #expect(duration == .seconds(3))
        #expect((CompactDuration.seconds(3) * 2).nanoseconds == 6_000_000_000)
        #expect((CompactDuration.seconds(3) / 2).nanoseconds == 1_500_000_000)
        #expect(CompactDuration.seconds(3) / CompactDuration.seconds(2) == 1.5)
        #expect(CompactDuration.zero.nanoseconds == 0)
    }

    @Test func `ordering follows the nanosecond count`() {
        #expect(CompactDuration.nanoseconds(1) > .zero)
        #expect(CompactDuration.nanoseconds(-1) < .zero)
        #expect(CompactDuration.milliseconds(1) > CompactDuration.microseconds(999))
        #expect(Set([CompactDuration.seconds(1), .milliseconds(1_000)]).count == 1)
    }
}
