#if !os(WASI)

import SystemClock
import Testing

@Suite
struct ResourceUsageTests {
    @Test(arguments: TestClock<Swift.Duration>.allResourceUsageClocks)
    func `every clock reads`(testClock: TestClock<Swift.Duration>) {
        _ = testClock.clock.now
    }

    @Test(arguments: TestClock<Swift.Duration>.allResourceUsageClocks)
    func `every clock reports a positive resolution`(testClock: TestClock<Swift.Duration>) {
        #expect(testClock.clock.minimumResolution > .zero)
    }

    @Test(arguments: TestClock<Swift.Duration>.allResourceUsageClocks)
    func `no clock ever goes backwards`(testClock: TestClock<Swift.Duration>) {
        var previous = testClock.clock.now
        for _ in 0..<1_000 {
            let current = testClock.clock.now
            #expect(current >= previous)
            previous = current
        }
    }

    /// The user and system clocks split the very reading the whole cpu-time clock takes, so they must add back up
    /// to it beyond the microsecond each is rounded to.
    @Test(
        arguments: [
            (
                user: GenericSystemClock<Swift.Duration>.processUserTime,
                system: GenericSystemClock<Swift.Duration>.processSystemTime,
                whole: GenericSystemClock<Swift.Duration>.processCPUTime
            ),
            (
                user: GenericSystemClock<Swift.Duration>.threadUserTime,
                system: GenericSystemClock<Swift.Duration>.threadSystemTime,
                whole: GenericSystemClock<Swift.Duration>.threadCPUTime
            ),
        ]
    )
    func `the user and system clocks add up to the whole CPU time clock`(
        user: GenericSystemClock<Swift.Duration>,
        system: GenericSystemClock<Swift.Duration>,
        whole: GenericSystemClock<Swift.Duration>
    ) {
        let epoch = GenericSystemClock<Swift.Duration>.Instant.epoch
        let total = epoch.duration(to: user.now) + epoch.duration(to: system.now)
        #expect(isClose(total, epoch.duration(to: whole.now), within: .milliseconds(10)))
    }

    @Test(
        arguments: [
            GenericSystemClock<Swift.Duration>.processUserTime,
            GenericSystemClock<Swift.Duration>.threadUserTime,
        ]
    )
    func `busy work advances the user clock`(clock: GenericSystemClock<Swift.Duration>) {
        let start = clock.now

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

        #expect(start.duration(to: clock.now) > .zero)
    }

    @Test(
        arguments: [
            (
                thread: GenericSystemClock<Swift.Duration>.threadUserTime,
                process: GenericSystemClock<Swift.Duration>.processUserTime
            ),
            (
                thread: GenericSystemClock<Swift.Duration>.threadSystemTime,
                process: GenericSystemClock<Swift.Duration>.processSystemTime
            ),
        ]
    )
    func `a thread never outruns its process`(
        thread: GenericSystemClock<Swift.Duration>,
        process: GenericSystemClock<Swift.Duration>
    ) {
        let epoch = GenericSystemClock<Swift.Duration>.Instant.epoch
        let threadTime = epoch.duration(to: thread.now)
        let processTime = epoch.duration(to: process.now)
        #expect(threadTime <= processTime + .milliseconds(50))
    }
}

#endif
