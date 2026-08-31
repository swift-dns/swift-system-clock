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
    <a href="https://swift.org">
        <img
            src="https://design.vapor.codes/images/swift63up.svg"
            alt="Swift 6.3+"
        >
    </a>
</p>

# swift-system-clock

Implements `SystemClock` which reads the operating system clock with no overhead.

## Table of Contents

- [Usage](#usage)
  - [Default Clocks](#default-clocks)
  - [Custom Clocks](#custom-clocks)
  - [Sleeping](#sleeping)
- [Performance](#performance)

## Usage

### Default Clocks

`SystemClock` conforms to `Clock`, so it works just like stdlib's `ContinuousClock`/`SuspendingClock`:

```swift
import SystemClock

let elapsed = SystemClock.suspending.measure {
    expensiveWork()
}

let now = SystemClock.realtime.now
```

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

### Sleeping

Currently the sleep functions are blocking and are discouraged to use.
Later they'll either not exist (crash on call) or become non-blocking.

## Performance

| Benchmark        | swift-system-clock | Standard library |
| ---------------- | ------------------ | ---------------- |
| `continuous.now` | 10.9 ns            | 26.8 ns          |
| `suspending.now` | 11.1 ns            | 26.5 ns          |
