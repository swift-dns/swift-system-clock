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
        blackHole(SystemClock<CompactDuration>.systemRealtime.now)
    }

    Benchmark(
        "Reading_Realtime_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemRealtime.now)
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
        blackHole(SystemClock<CompactDuration>.systemRealtimeCoarse.now)
    }

    Benchmark(
        "Reading_Realtime_Coarse_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemRealtimeCoarse.now)
    }

    // MARK: - Reading_Continuous

    Benchmark(
        "Reading_Continuous_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemContinuous.now)
    }

    Benchmark(
        "Reading_Continuous_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemContinuous.now)
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
        blackHole(SystemClock<CompactDuration>.systemContinuousCoarse.now)
    }

    Benchmark(
        "Reading_Continuous_Coarse_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemContinuousCoarse.now)
    }

    // MARK: - Reading_Suspending

    Benchmark(
        "Reading_Suspending_Malloc",
        configuration: .init(
            metrics: [.mallocCountTotal],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemSuspending.now)
    }

    Benchmark(
        "Reading_Suspending_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemSuspending.now)
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
        blackHole(SystemClock<CompactDuration>.systemSuspendingCoarse.now)
    }

    Benchmark(
        "Reading_Suspending_Coarse_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemSuspendingCoarse.now)
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
        blackHole(SystemClock<CompactDuration>.systemProcessCPUTime.now)
    }

    Benchmark(
        "Reading_Process_CPU_Time_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemProcessCPUTime.now)
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
        blackHole(SystemClock<CompactDuration>.systemThreadCPUTime.now)
    }

    Benchmark(
        "Reading_Thread_CPU_Time_Instructions",
        configuration: .init(
            metrics: [.instructions],
            warmupIterations: 1,
            maxIterations: 10
        )
    ) { benchmark in
        blackHole(SystemClock<CompactDuration>.systemThreadCPUTime.now)
    }
}
