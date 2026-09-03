import SystemClock

/// The clocks that exist on the platform the tests are running on, with what is known about
/// each one, so that every test below covers all of them.
struct TestClock<Duration: SystemDurationProtocol>: Sendable, CustomStringConvertible {
    var name: String
    var clock: GenericSystemClock<Duration>
    /// Whether two readings must come back in order.
    var isMonotonic: Bool
    /// Whether it advances with elapsed time rather than with work done.
    var followsElapsedTime: Bool

    var description: String {
        self.name
    }
}

extension TestClock {
    static var all: [TestClock] {
        [
            TestClock(
                name: "realtime",
                clock: .realtime,
                isMonotonic: false,
                followsElapsedTime: true
            ),
            TestClock(
                name: "realtimeCoarse",
                clock: .realtimeCoarse,
                isMonotonic: false,
                followsElapsedTime: true
            ),
            TestClock(
                name: "continuous",
                clock: .continuous,
                isMonotonic: true,
                followsElapsedTime: true
            ),
            TestClock(
                name: "continuousCoarse",
                clock: .continuousCoarse,
                isMonotonic: true,
                followsElapsedTime: true
            ),
            TestClock(
                name: "suspending",
                clock: .suspending,
                isMonotonic: true,
                followsElapsedTime: true
            ),
            TestClock(
                name: "suspendingCoarse",
                clock: .suspendingCoarse,
                isMonotonic: true,
                followsElapsedTime: true
            ),
            TestClock(
                name: "processCPUTime",
                clock: .processCPUTime,
                isMonotonic: true,
                followsElapsedTime: false
            ),
            TestClock(
                name: "threadCPUTime",
                clock: .threadCPUTime,
                isMonotonic: true,
                followsElapsedTime: false
            ),
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
}

extension TestClock {
    static var allResourceUsageClocks: [TestClock] {
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
}
