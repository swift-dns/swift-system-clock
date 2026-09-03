import SystemClock
import Testing

/// Whether two readings of the same underlying clock agree, allowing for the two reads not
/// happening at the same instant.
func isClose(
    _ lhs: Duration,
    _ rhs: Duration,
    within tolerance: Duration = .milliseconds(100)
)
    -> Bool
{
    let difference = lhs - rhs
    return difference > .zero - tolerance && difference < tolerance
}

@Suite
struct SystemClockTests {
    @Test(arguments: TestClock<Swift.Duration>.all)
    func `every clock reads`(testClock: TestClock<Swift.Duration>) {
        let first = testClock.clock.now
        let second = testClock.clock.now
        guard testClock.followsElapsedTime else {
            return
        }
        #expect(
            first != GenericSystemClock<Swift.Duration>.Instant.epoch
                || second != GenericSystemClock<Swift.Duration>.Instant.epoch
        )
    }

    @Test(arguments: TestClock<Swift.Duration>.all)
    func `every clock reports a positive resolution`(testClock: TestClock<Swift.Duration>) {
        #expect(testClock.clock.minimumResolution > .zero)
    }

    @Test(arguments: TestClock<Swift.Duration>.all)
    func `monotonic clocks never go backwards`(testClock: TestClock<Swift.Duration>) {
        guard testClock.isMonotonic else {
            return
        }
        var previous = testClock.clock.now
        for _ in 0..<1_000 {
            let current = testClock.clock.now
            #expect(current >= previous)
            previous = current
        }
    }

    @Test(arguments: TestClock<Swift.Duration>.all)
    func `clocks that follow elapsed time advance on their own`(
        testClock: TestClock<Swift.Duration>
    ) async throws {
        guard testClock.followsElapsedTime else {
            return
        }
        let start = testClock.clock.now
        try await Task.sleep(for: .milliseconds(50), clock: .continuous)
        let elapsed = start.duration(to: testClock.clock.now)
        /// Generous on both sides: a coarse clock lags by a tick, and a loaded machine
        /// oversleeps.
        #expect(elapsed > .milliseconds(20))
        #expect(elapsed < .seconds(5))
    }

    /// `realtime` counts from the Unix epoch, so its reading has to land in a plausible year.
    @Test func `realtime reads a plausible calendar time`() {
        let seconds = GenericSystemClock<Swift.Duration>.Instant.epoch.duration(
            to: GenericSystemClock<Swift.Duration>.realtime.now
        ).components
            .seconds
        /// 2025-01-01 and 2100-01-01.
        #expect(seconds > 1_735_689_600)
        #expect(seconds < 4_102_444_800)
    }

    /// A coarse clock is the same clock read more cheaply, so it may lag but must not disagree.
    @Test(
        arguments: [
            (
                coarse: GenericSystemClock<Swift.Duration>.realtimeCoarse,
                precise: GenericSystemClock<Swift.Duration>.realtime
            ),
            (
                coarse: GenericSystemClock<Swift.Duration>.continuousCoarse,
                precise: GenericSystemClock<Swift.Duration>.continuous
            ),
            (
                coarse: GenericSystemClock<Swift.Duration>.suspendingCoarse,
                precise: GenericSystemClock<Swift.Duration>.suspending
            ),
        ]
    )
    func `a coarse clock stays close to its precise sibling`(
        coarse: GenericSystemClock<Swift.Duration>,
        precise: GenericSystemClock<Swift.Duration>
    ) {
        let coarseReading = coarse.now
        let preciseReading = precise.now
        let difference = coarseReading.duration(to: preciseReading)
        #expect(difference > .milliseconds(-100))
        #expect(difference < .milliseconds(100))
    }

    /// `continuous` and `suspending` read the same underlying clocks the standard library's
    /// `ContinuousClock` and `SuspendingClock` do on this platform.
    @Test func `continuous and suspending track the standard library clocks`() {
        let systemContinuous = GenericSystemClock<Swift.Duration>.continuous.now
        let stdlibContinuous = ContinuousClock().now

        let systemSuspending = GenericSystemClock<Swift.Duration>.suspending.now
        let stdlibSuspending = SuspendingClock().now

        let continuousElapsed = GenericSystemClock<Swift.Duration>.Instant.epoch.duration(
            to: systemContinuous
        )
        let suspendingElapsed = GenericSystemClock<Swift.Duration>.Instant.epoch.duration(
            to: systemSuspending
        )

        let stdlibContinuousElapsed = ContinuousClock().systemEpoch.duration(to: stdlibContinuous)
        let stdlibSuspendingElapsed = SuspendingClock().systemEpoch.duration(to: stdlibSuspending)

        #expect(isClose(continuousElapsed, stdlibContinuousElapsed))
        #expect(isClose(suspendingElapsed, stdlibSuspendingElapsed))
    }

    #if !os(WASI)
    @Test func `cpu time clocks advance while burning cpu`() {
        let processStart = GenericSystemClock<Swift.Duration>.processCPUTime.now
        let threadStart = GenericSystemClock<Swift.Duration>.threadCPUTime.now

        let burnStart = GenericSystemClock<Swift.Duration>.suspending.now
        var accumulator: UInt64 = 0
        var index: UInt64 = 0
        while burnStart.duration(to: GenericSystemClock<Swift.Duration>.suspending.now)
            < .milliseconds(200)
        {
            accumulator = accumulator &+ index &* 2_654_435_761
            index &+= 1
        }
        #expect(accumulator != 0)

        #expect(
            processStart.duration(to: GenericSystemClock<Swift.Duration>.processCPUTime.now) > .zero
        )
        #expect(
            threadStart.duration(to: GenericSystemClock<Swift.Duration>.threadCPUTime.now) > .zero
        )
    }
    #endif
}
