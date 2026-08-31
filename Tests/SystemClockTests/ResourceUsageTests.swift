#if !os(WASI)

import SystemClock
import Testing

extension SystemClock where Duration: SystemDurationProtocol {
    static var processUserTime: SystemClock {
        SystemClock(
            darwin: .processUserTime,
            linux: .processUserTime,
            windows: .processUserTime,
            freebsd: .processUserTime,
            openbsd: .processUserTime,
            wasi: .monotonic
        )
    }

    static var processSystemTime: SystemClock {
        SystemClock(
            darwin: .processSystemTime,
            linux: .processSystemTime,
            windows: .processKernelTime,
            freebsd: .processSystemTime,
            openbsd: .processSystemTime,
            wasi: .monotonic
        )
    }

    static var threadUserTime: SystemClock {
        SystemClock(
            darwin: .threadUserTime,
            linux: .threadUserTime,
            windows: .threadUserTime,
            freebsd: .threadUserTime,
            openbsd: .threadUserTime,
            wasi: .monotonic
        )
    }

    static var threadSystemTime: SystemClock {
        SystemClock(
            darwin: .threadSystemTime,
            linux: .threadSystemTime,
            windows: .threadKernelTime,
            freebsd: .threadSystemTime,
            openbsd: .threadSystemTime,
            wasi: .monotonic
        )
    }
}

@Suite
struct ResourceUsageTests {
    static var all: [TestClock<Swift.Duration>] {
        [
            TestClock(
                name: "processUserTime",
                clock: .processUserTime,
                isMonotonic: true,
                followsElapsedTime: false
            ),
            TestClock(
                name: "processSystemTime",
                clock: .processSystemTime,
                isMonotonic: true,
                followsElapsedTime: false
            ),
            TestClock(
                name: "threadUserTime",
                clock: .threadUserTime,
                isMonotonic: true,
                followsElapsedTime: false
            ),
            TestClock(
                name: "threadSystemTime",
                clock: .threadSystemTime,
                isMonotonic: true,
                followsElapsedTime: false
            ),
        ]
    }

    @Test(arguments: Self.all)
    func `every half reads`(testClock: TestClock<Swift.Duration>) {
        _ = testClock.clock.now
    }

    @Test(arguments: Self.all)
    func `every half reports a positive resolution`(testClock: TestClock<Swift.Duration>) {
        #expect(testClock.clock.minimumResolution > .zero)
    }

    @Test(arguments: Self.all)
    func `no half ever goes backwards`(testClock: TestClock<Swift.Duration>) {
        var previous = testClock.clock.now
        for _ in 0..<1_000 {
            let current = testClock.clock.now
            #expect(current >= previous)
            previous = current
        }
    }

    /// The halves split the very reading the whole cpu-time clock takes, so they must add back up
    /// to it beyond the microsecond each is rounded to.
    @Test(
        arguments: [
            (
                user: SystemClock<Swift.Duration>.processUserTime,
                system: SystemClock<Swift.Duration>.processSystemTime,
                whole: SystemClock<Swift.Duration>.processCPUTime
            ),
            (
                user: SystemClock<Swift.Duration>.threadUserTime,
                system: SystemClock<Swift.Duration>.threadSystemTime,
                whole: SystemClock<Swift.Duration>.threadCPUTime
            ),
        ]
    )
    func `the halves add up to the whole`(
        user: SystemClock<Swift.Duration>,
        system: SystemClock<Swift.Duration>,
        whole: SystemClock<Swift.Duration>
    ) {
        let epoch = SystemClock<Swift.Duration>.Instant.epoch
        let total = epoch.duration(to: user.now) + epoch.duration(to: system.now)
        #expect(isClose(total, epoch.duration(to: whole.now), within: .milliseconds(50)))
    }

    @Test(
        arguments: [
            SystemClock<Swift.Duration>.processUserTime,
            SystemClock<Swift.Duration>.threadUserTime,
        ]
    )
    func `busy work advances the user half`(clock: SystemClock<Swift.Duration>) {
        let start = clock.now

        let burnStart = SystemClock<Swift.Duration>.suspending.now
        var accumulator: UInt64 = 0
        var index: UInt64 = 0
        while burnStart.duration(to: SystemClock<Swift.Duration>.suspending.now)
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
                thread: SystemClock<Swift.Duration>.threadUserTime,
                process: SystemClock<Swift.Duration>.processUserTime
            ),
            (
                thread: SystemClock<Swift.Duration>.threadSystemTime,
                process: SystemClock<Swift.Duration>.processSystemTime
            ),
        ]
    )
    func `a thread never outruns its process`(
        thread: SystemClock<Swift.Duration>,
        process: SystemClock<Swift.Duration>
    ) {
        let epoch = SystemClock<Swift.Duration>.Instant.epoch
        let threadTime = epoch.duration(to: thread.now)
        let processTime = epoch.duration(to: process.now)
        #expect(threadTime <= processTime + .milliseconds(50))
    }
}

#endif
