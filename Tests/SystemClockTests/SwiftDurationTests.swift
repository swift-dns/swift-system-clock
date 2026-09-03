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

    @Test func `the largest readings that fit are exact`() {
        let largest = Swift.Duration(
            secondsComponent: 9_223_372_036,
            attosecondsComponent: 854_775_807_000_000_000
        )
        #expect(largest.nanoseconds == .max)
        let smallest = Swift.Duration(
            secondsComponent: -9_223_372_036,
            attosecondsComponent: -854_775_808_000_000_000
        )
        #expect(smallest.nanoseconds == .min)
    }

    #if os(macOS) || os(Linux) || os(FreeBSD) || os(OpenBSD) || os(Windows)
    @Test func `a reading whose seconds overrun the scale traps`() async {
        await #expect(processExitsWith: .failure) {
            _ = Swift.Duration.seconds(Int64.max).nanoseconds
        }
        await #expect(processExitsWith: .failure) {
            _ = Swift.Duration.seconds(Int64.min).nanoseconds
        }
    }

    @Test func `a reading whose attoseconds overrun the scale traps`() async {
        await #expect(processExitsWith: .failure) {
            _ =
                Swift.Duration(
                    secondsComponent: 9_223_372_036,
                    attosecondsComponent: 854_775_808_000_000_000
                ).nanoseconds
        }
        await #expect(processExitsWith: .failure) {
            _ =
                Swift.Duration(
                    secondsComponent: -9_223_372_036,
                    attosecondsComponent: -854_775_809_000_000_000
                ).nanoseconds
        }
    }

    @Test func `a compact duration built from a Swift Duration outside its range traps`() async {
        await #expect(processExitsWith: .failure) {
            _ = CompactDuration(Swift.Duration.seconds(1e10))
        }
    }
    #endif
}
