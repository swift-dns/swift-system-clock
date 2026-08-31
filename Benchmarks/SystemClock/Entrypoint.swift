import Benchmark
import SystemClock

let benchmarks: @Sendable () -> Void = {
    unsafe Benchmark.defaultConfiguration.maxDuration = .seconds(5)

    readingBenchmarks()
}
