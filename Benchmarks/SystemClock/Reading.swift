import Benchmark
import SystemClock

let readingBenchmarks: @Sendable () -> Void = {
    // MARK: - Reading_Continuous

    Benchmark(
        "Reading_Continuous_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SystemClock<Swift.Duration>.continuous.now)
        }
    }

    // MARK: - Reading_Continuous_Stdlib

    Benchmark(
        "Reading_Continuous_Stdlib_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(ContinuousClock.now)
        }
    }

    // MARK: - Reading_Continuous_Coarse

    Benchmark(
        "Reading_Continuous_Coarse_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SystemClock<Swift.Duration>.continuousCoarse.now)
        }
    }

    // MARK: - Reading_Suspending

    Benchmark(
        "Reading_Suspending_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SystemClock<Swift.Duration>.suspending.now)
        }
    }

    // MARK: - Reading_Suspending_Stdlib

    Benchmark(
        "Reading_Suspending_Stdlib_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SuspendingClock.now)
        }
    }

    // MARK: - Reading_Suspending_Coarse

    Benchmark(
        "Reading_Suspending_Coarse_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SystemClock<Swift.Duration>.suspendingCoarse.now)
        }
    }

    // MARK: - Reading_Realtime

    Benchmark(
        "Reading_Realtime_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SystemClock<Swift.Duration>.realtime.now)
        }
    }

    // MARK: - Reading_Realtime_Coarse

    Benchmark(
        "Reading_Realtime_Coarse_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SystemClock<Swift.Duration>.realtimeCoarse.now)
        }
    }

    // MARK: - Reading_Process_CPU_Time

    Benchmark(
        "Reading_Process_CPU_Time_1M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<1_000_000 {
            blackHole(SystemClock<Swift.Duration>.processCPUTime.now)
        }
    }

    // MARK: - Reading_Stored_Clock

    /// A clock held in a variable cannot fold its id into an immediate, so this is what a
    /// caller pays when the clock is chosen at runtime rather than named at the call site.
    let stored = SystemClock<Swift.Duration>.suspending
    Benchmark(
        "Reading_Stored_Clock_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(stored.now)
        }
    }

    // MARK: - Reading_Minimum_Resolution

    Benchmark(
        "Reading_Minimum_Resolution_1M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<1_000_000 {
            blackHole(SystemClock<Swift.Duration>.suspending.minimumResolution)
        }
    }
}
