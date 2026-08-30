import Benchmark
import SystemClock

let instantBenchmarks: @Sendable () -> Void = {
    // MARK: - Instant_Duration_To

    let start = SystemClock<Swift.Duration>.suspending.now
    let end = start.advanced(by: .milliseconds(1_500))
    Benchmark(
        "Instant_Duration_To_50M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<50_000_000 {
            blackHole(start.duration(to: end))
        }
    }

    // MARK: - Instant_Advanced_By

    Benchmark(
        "Instant_Advanced_By_50M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<50_000_000 {
            blackHole(start.advanced(by: .nanoseconds(1)))
        }
    }

    // MARK: - Instant_Comparison

    Benchmark(
        "Instant_Comparison_50M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<50_000_000 {
            blackHole(start < end)
        }
    }

    // MARK: - Measure_Empty_Work

    Benchmark(
        "Measure_Empty_Work_5M",
        configuration: .init(
            metrics: [.cpuUser],
            warmupIterations: 5,
            maxIterations: 1000
        )
    ) { benchmark in
        for _ in 0..<5_000_000 {
            blackHole(SystemClock<Swift.Duration>.suspending.measure {})
        }
    }
}
