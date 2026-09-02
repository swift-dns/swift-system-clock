import SystemClock
import Testing

@Suite
struct SwiftDurationTests {
    @Test func `a reading that fits keeps every nanosecond`() {
        #expect(Swift.Duration.nanoseconds(1_929).nanoseconds == 1_929)
        #expect(Swift.Duration.nanoseconds(-1_929).nanoseconds == -1_929)
        let largest = Swift.Duration(
            secondsComponent: 9_223_372_035,
            attosecondsComponent: 999_999_999_999_999_999
        )
        #expect(largest.nanoseconds == 9_223_372_035_999_999_999)
    }

    @Test func `attoseconds below a nanosecond are dropped`() {
        let subNanosecond = Swift.Duration(
            secondsComponent: 0,
            attosecondsComponent: 999_999_999
        )
        #expect(subNanosecond.nanoseconds == 0)
        let remainder = Swift.Duration(
            secondsComponent: 1,
            attosecondsComponent: 1_999_999_999
        )
        #expect(remainder.nanoseconds == 1_000_000_001)
    }

    @Test func `a reading whose seconds overrun the scale saturates`() {
        #expect(Swift.Duration.seconds(Int64.max).nanoseconds == .max)
        #expect(Swift.Duration.seconds(Int64.min).nanoseconds == .min)
    }

    @Test func `a reading whose attoseconds overrun the scale saturates`() {
        let overMaximum = Swift.Duration(
            secondsComponent: 9_223_372_036,
            attosecondsComponent: 999_999_999_999_999_999
        )
        #expect(overMaximum.nanoseconds == .max)
        let underMinimum = Swift.Duration(
            secondsComponent: -9_223_372_036,
            attosecondsComponent: -999_999_999_999_999_999
        )
        #expect(underMinimum.nanoseconds == .min)
    }
}
