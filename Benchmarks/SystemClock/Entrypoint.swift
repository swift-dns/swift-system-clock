import Benchmark
import SystemClock

let benchmarks: @Sendable () -> Void = {
    unsafe Benchmark.defaultConfiguration.maxDuration = .seconds(5)

    Benchmark(
        "111_Machine_Warmup_Benchmark",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 1,
            maxIterations: 1_000_000
        )
    ) { benchmark in
        for _ in 0..<1_000 {
            blackHole(SystemClock<CompactDuration>.systemContinuous.now)
        }
    }

    readingBenchmarks()
}
