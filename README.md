<p>
    <a href="https://github.com/swift-dns/swift-system-clock/actions/workflows/unit-tests.yml">
        <img
            src="https://img.shields.io/github/actions/workflow/status/swift-dns/swift-system-clock/unit-tests.yml?event=push&style=plastic&logo=github&label=unit-tests&logoColor=%23ccc"
            alt="Unit Tests CI"
        >
    </a>
    <a href="https://github.com/swift-dns/swift-system-clock/actions/workflows/benchmarks.yml">
        <img
            src="https://img.shields.io/github/actions/workflow/status/swift-dns/swift-system-clock/benchmarks.yml?event=push&style=plastic&logo=github&label=benchmarks&logoColor=%23ccc"
            alt="Benchmarks CI"
        >
    </a>
    <a href="https://codecov.io/gh/swift-dns/swift-system-clock">
        <img
            src="https://codecov.io/gh/swift-dns/swift-system-clock/graph/badge.svg?token=KW7Y46RYYD"
            alt="Codecov Tests Code Coverage"
        >
    </a>
    <a href="https://swift.org">
        <img
            src="https://design.vapor.codes/images/swift63up.svg"
            alt="Swift 6.3+"
        >
    </a>
</p>

# swift-system-clock

Implements `SystemClock` which reads operating system clocks with no overhead.

Supports `Darwin` (`Apple` platforms), `Linux` (Including `Android`), `Windows`, `FreeBSD`, `OpenBSD` and `WASI`.
Also compiles on embedded platforms in a similar fashion to Swift standard library's `ContinuousClock`.

## Table of Contents

- [Usage](#usage)
  - [Default Clocks](#default-clocks)
  - [Custom Clocks](#custom-clocks)
  - [Sleeping](#sleeping)
- [Performance](#performance)
  - [Against Darwin](#against-darwin)
  - [Against glibc](#against-glibc)

## Usage

### Default Clocks

`SystemClock` conforms to `Clock`, so it works just like stdlib's `ContinuousClock`/`SuspendingClock`:

```swift
import SystemClock

let elapsed: CompactDuration = SystemClock.suspending.measure {
    expensiveWork()
}

let now = SystemClock.realtime.now
```

> [!NOTE]
> `SystemClock` defaults to using `CompactDuration` although `Swift`'s `Duration` is also supported.   
> `CompactDuration` is a lower-precision `Duration` that only keeps `nanoseconds`.   
> The extra precision is unneeded 99+% of the time in a system-clock context and would be a waste of resources.

### Custom Clocks

You can hand-craft a system clock that uses your desired clocks on each platform:

```swift
let clock = SystemClock(
    darwin: .monotonicRaw,
    linux: .monotonicRaw,
    windows: .performanceCounter,
    freebsd: .monotonicPrecise,
    openbsd: .monotonic,
    wasi: .monotonic
)
```

Every Apple platforms takes `darwin`. Android takes `linux`.

> [!NOTE]
> `SystemClock` as a library will only compile the required parts of the code for minimum compilation effect.

### Sleeping

> [!WARNING]
> Currently the sleep functions are blocking and are discouraged to use.   
> Later they'll either not exist (crash on call) or become non-blocking.


## Performance

* Below are benchmarks of this library against the 2 clocks that Swift standard library provides, on macOS and Linux.
* **In all cases, swift-system-clock wins against the Swift standard library APIs.**
* The benchmarks are done with `SystemClock`'s `.continuous`/`.suspending` vs stdlib's `ContinuousClock`/`SuspendingClock`.

### Against Darwin

These were performed on my M1 Pro MacBook, on macOS 27.

| Benchmark        | `SystemClock` (ns/op) | Standard Library (ns/op) | Speedup |
| ---------------- | --------------------- | ------------------------ | ------- |
| `continuous.now` | 10.6 ns               | 25.6 ns                  | 2.41x   |
| `suspending.now` | 10.8 ns               | 25.3 ns                  | 2.33x   |

| Benchmark        | `SystemClock` instructions | Standard Library instructions |
| ---------------- | -------------------------- | ----------------------------- |
| `continuous.now` | 94                         | 205                           |
| `suspending.now` | 101                        | 210                           |

### Against glibc

These were performed on a dedicated-cpu-core AMD EPYC-Milan VM from Hetzner, on Ubuntu 24.04.

| Benchmark        | `SystemClock` (ns/op) | Standard Library (ns/op) | Speedup |
| ---------------- | --------------------- | ------------------------ | ------- |
| `continuous.now` | 26.8 ns               | 29.8 ns                  | 1.11x   |
| `suspending.now` | 26.8 ns               | 29.5 ns                  | 1.10x   |

| Benchmark        | `SystemClock` instructions | Standard Library instructions |
| ---------------- | -------------------------- | ----------------------------- |
| `continuous.now` | 133                        | 200                           |
| `suspending.now` | 133                        | 198                           |

#### Additional Notes

* To see up to date information about performance of this package, please go to this [benchmarks list](https://github.com/swift-dns/swift-system-clock/actions/workflows/benchmarks.yml?query=branch%3Amain), and choose the most recent benchmark. You'll see a summary of the benchmark there.
* The results above are all reproducible by simply running `scripts/benchmark.sh` on a machine of your own.
