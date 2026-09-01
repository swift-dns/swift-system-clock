import Benchmark
import SystemClock

let readingBenchmarks: @Sendable () -> Void = {
    // MARK: - Reading_Realtime

    Benchmark(
        "Reading_Realtime_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemRealtime.now)
    }

    Benchmark(
        "Reading_Realtime_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemRealtime.now)
        }
    }

    // MARK: - Reading_Realtime_Coarse

    Benchmark(
        "Reading_Realtime_Coarse_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemRealtimeCoarse.now)
    }

    Benchmark(
        "Reading_Realtime_Coarse_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemRealtimeCoarse.now)
        }
    }

    // MARK: - Reading_Continuous

    Benchmark(
        "Reading_Continuous_CPU_4M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<4_000_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemContinuous.now)
        }
    }

    Benchmark(
        "Reading_Continuous_Stdlib_CPU_4M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<4_000_000 {
            blackHole(ContinuousClock.now)
        }
    }

    Benchmark(
        "Reading_Continuous_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemContinuous.now)
    }

    Benchmark(
        "Reading_Continuous_Stdlib_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(ContinuousClock.now)
    }

    Benchmark(
        "Reading_Continuous_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemContinuous.now)
        }
    }

    Benchmark(
        "Reading_Continuous_Stdlib_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(ContinuousClock.now)
        }
    }

    // MARK: - Reading_Continuous_Coarse

    Benchmark(
        "Reading_Continuous_Coarse_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemContinuousCoarse.now)
    }

    Benchmark(
        "Reading_Continuous_Coarse_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemContinuousCoarse.now)
        }
    }

    // MARK: - Reading_Suspending

    Benchmark(
        "Reading_Suspending_CPU_4M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<4_000_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemSuspending.now)
        }
    }

    Benchmark(
        "Reading_Suspending_Stdlib_CPU_4M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<4_000_000 {
            blackHole(SuspendingClock.now)
        }
    }

    Benchmark(
        "Reading_Suspending_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemSuspending.now)
    }

    Benchmark(
        "Reading_Suspending_Stdlib_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SuspendingClock.now)
    }

    Benchmark(
        "Reading_Suspending_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemSuspending.now)
        }
    }

    Benchmark(
        "Reading_Suspending_Stdlib_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(SuspendingClock.now)
        }
    }

    // MARK: - Reading_Suspending_Coarse

    Benchmark(
        "Reading_Suspending_Coarse_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemSuspendingCoarse.now)
    }

    Benchmark(
        "Reading_Suspending_Coarse_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemSuspendingCoarse.now)
        }
    }

    // MARK: - Reading_Process_CPU_Time

    Benchmark(
        "Reading_Process_CPU_Time_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemProcessCPUTime.now)
    }

    Benchmark(
        "Reading_Process_CPU_Time_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemProcessCPUTime.now)
        }
    }

    // MARK: - Reading_Thread_CPU_Time

    Benchmark(
        "Reading_Thread_CPU_Time_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(GenericSystemClock<CompactDuration>.systemThreadCPUTime.now)
    }

    Benchmark(
        "Reading_Thread_CPU_Time_Instructions_10K",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        for _ in 0..<10_000 {
            blackHole(GenericSystemClock<CompactDuration>.systemThreadCPUTime.now)
        }
    }
}
