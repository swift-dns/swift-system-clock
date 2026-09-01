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

Supports `Darwin` (`Apple` platforms), `Linux` (Including `Android`), `Windows`, `FreeBSD`, `OpenBSD`[^1] and `WASI`.
Also compiles on embedded platforms in a similar fashion to Swift standard library's `ContinuousClock`.

[^1]: Swift support for `OpenBSD` is a work-in-progress. This library doesn't have CI for `OpenBSD` yet so things can be flaky.

## Table of Contents

- [Usage](#usage)
  - [Default Clocks](#default-clocks)
  - [Custom Clocks](#custom-clocks)
  - [Sleeping](#sleeping)
- [Cheat Sheet](#cheat-sheet)
- [Platform Clocks](#platform-clocks)
  - [Supported Clocks](#supported-clocks)
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
/// `SystemClock` == `GenericSystemClock<CompactDuration>`
let realtimeClock = SystemClock(
    darwin: .realtime,
    linux: .realtime,
    windows: .systemTimePrecise,
    freebsd: .realtimePrecise,
    openbsd: .realtime,
    wasi: .realtime
)

/// You can use `Swift.Duration` as well although `CompactDuration` is generally recommended.
let processCPUTimeClock = GenericSystemClock<Swift.Duration>(
    darwin: .processCPUTime,
    linux: .processCPUTime,
    windows: .processTime,
    freebsd: .processCPUTime,
    openbsd: .processCPUTime,
    wasi: .monotonic
)
```

Every Apple platforms takes `darwin`. Android takes `linux`.

> [!NOTE]
> `SystemClock` will only compile code for the platform you're deploying too.   
> Essentially, `SystemClock` is a multi-platform library, but that comes for free with no overhead.

### Sleeping

> [!WARNING]
> Currently the sleep functions are blocking and are discouraged to use.   
> Later they'll either not exist (crash on call) or become non-blocking.

## Cheat Sheet

For convenience, here is a cheat sheet that should work for most users:

| If you want to                | Use                               |
| ----------------------------- | --------------------------------- |
| ... know what time it is      | `realtime`                        |
| ... stamp a log line, cheaply | `realtimeCoarse`                  |

| If you want to measure how long                                     | Use                               |
| ------------------------------------------------------------------- | --------------------------------- |
| ... some work took, including system sleeps                         | `continuous` / `continuousCoarse` |
| ... some work took, excluding system sleeps                         | `suspending` / `suspendingCoarse` |
| ... the process spent running on all CPUs, combined                 | `processCPUTime`                  |
| ... the thread spent running on any CPU core                        | `threadCPUTime`                   |
| ... the process spent running in user mode on all CPUs, combined    | `processUserTime`                 |
| ... the thread spent running in user mode on any CPU core           | `threadUserTime`                  |
| ... the kernel spent running for this process on all CPUs, combined | `processSystemTime`               |
| ... the kernel spent running for this thread on any CPU core        | `threadSystemTime`                |

* "coarse" clocks are cheaper but also less precise. Sometimes you'll have to make that trade-off.
* An example of a system sleep is when you close your laptop's lid.
* An example of the kernel running on behalf of your process is when you read a file, or send data over a socket.
* Generally, `[process/thread]UserTime` + `[process/thread]SystemTime` ~= `[process/thread]CPUTime`.

> [!NOTE]
> `WASI` only supports 2 clocks: `monotonic` and `realtime`.
> When a clock is unavailable on any platform, `SystemClock` simply falls back to the best available fit.

## Platform Clocks

* This library supports all clocks that Unix systems via [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html).
* For Windows, this library follows [Acquiring high-resolution time stamps](https://learn.microsoft.com/en-us/windows/win32/sysinfo/acquiring-high-resolution-time-stamps).
* WASI only supports 2 clocks: `monotonic` and `realtime`.
* In few cases, for example for `processUserTime` and `threadUserTime`, this library uses alternative functions such as [getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html).

### Supported Clocks

Here is a list of all supported clocks on each platform.

> [!NOTE]
> The measured values come from specific hardware and kernel versions and are meant as hints.
> For better accuracy, measure under your own specific hardware and kernel.
> If you find a value widely incorrect, please file an issue or open a pull request for it.

<details>
  <summary><b>Darwin (Apple platforms)</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | ❌ Yes         |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 12ns @ 4GHz  |
| Cold read cost                    | ~ 200ns @ 4GHz |
| Step granularity                  | 1µs            |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ❌ Yes         |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 17ns @ 4GHz  |
| Cold read cost                    | ~ 165ns @ 4GHz |
| Step granularity                  | 1µs            |

</details>

<details>
  <summary><code>monotonicRaw</code> (<code>CLOCK_MONOTONIC_RAW</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 13ns @ 4GHz  |
| Cold read cost                    | ~ 135ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>monotonicRawApproximate</code> (<code>CLOCK_MONOTONIC_RAW_APPROX</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 1ms       |
| Typical read cost                 | ~ 5.5ns @ 4GHz |
| Cold read cost                    | ~ 230ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>uptimeRaw</code> (<code>CLOCK_UPTIME_RAW</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 13ns @ 4GHz  |
| Cold read cost                    | ~ 165ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>uptimeRawApproximate</code> (<code>CLOCK_UPTIME_RAW_APPROX</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 1ms       |
| Typical read cost                 | ~ 5ns @ 4GHz   |
| Cold read cost                    | ~ 165ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures CPU time used by this process

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 210ns @ 4GHz |
| Cold read cost                    | ~ 1.3µs @ 4GHz |
| Step granularity                  | 1µs            |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures CPU time used by this thread

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 115ns @ 4GHz |
| Cold read cost                    | ~ 460ns @ 4GHz |
| Step granularity                  | 125ns          |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://keith.github.io/xcode-man-pages/getrusage.2.html)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this process spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | ~ 210ns @ 4GHz   |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://keith.github.io/xcode-man-pages/getrusage.2.html)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this process's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | ~ 210ns @ 4GHz   |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>THREAD_BASIC_INFO</code>)</summary>

[thread_info(2)](https://developer.apple.com/documentation/kernel/1418630-thread_info)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this thread spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | ~ 460ns @ 4GHz   |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>THREAD_BASIC_INFO</code>)</summary>

[thread_info(2)](https://developer.apple.com/documentation/kernel/1418630-thread_info)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this thread's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | ~ 460ns @ 4GHz   |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

</details>

<details>
  <summary><b>Linux (Including Android)</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ❌ Yes          |
| Affected by NTP changes           | ❌ Yes          |
| Affected by system suspension     | ❌ Yes          |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ❌ Yes          |
| Reads a cached value              | ✅ No           |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 25ns @ 4GHz   |
| Cold read cost                    | ~ 10.6µs @ 4GHz |
| Step granularity                  | 20ns            |

</details>

<details>
  <summary><code>realtimeAlarm</code> (<code>CLOCK_REALTIME_ALARM</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | ❌ Yes         |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 135ns @ 4GHz |
| Cold read cost                    | ~ 4.6µs @ 4GHz |
| Step granularity                  | 140ns          |

</details>

<details>
  <summary><code>realtimeCoarse</code> (<code>CLOCK_REALTIME_COARSE</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | ❌ Yes         |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 2ms       |
| Typical read cost                 | ~ 4.5ns @ 4GHz |
| Cold read cost                    | ~ 9µs @ 4GHz   |
| Step granularity                  | 1ms            |

</details>

<details>
  <summary><code>tai</code> (<code>CLOCK_TAI</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, on the TAI timescale

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ❌ Yes          |
| Affected by NTP changes           | ❌ Yes          |
| Affected by system suspension     | ❌ Yes          |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ❌ Yes          |
| Reads a cached value              | ✅ No           |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 25ns @ 4GHz   |
| Cold read cost                    | ~ 10.8µs @ 4GHz |
| Step granularity                  | 20ns            |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, from an arbitrary point

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | ❌ Yes          |
| Affected by system suspension     | ✅ No           |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | ✅ No           |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 25ns @ 4GHz   |
| Cold read cost                    | ~ 10.8µs @ 4GHz |
| Step granularity                  | 20ns            |

</details>

<details>
  <summary><code>monotonicCoarse</code> (<code>CLOCK_MONOTONIC_COARSE</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ❌ Yes         |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 2ms       |
| Typical read cost                 | ~ 4.5ns @ 4GHz |
| Cold read cost                    | ~ 9µs @ 4GHz   |
| Step granularity                  | 1ms            |

</details>

<details>
  <summary><code>monotonicRaw</code> (<code>CLOCK_MONOTONIC_RAW</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, from an arbitrary point

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | ✅ No           |
| Affected by system suspension     | ✅ No           |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | ✅ No           |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 25ns @ 4GHz   |
| Cold read cost                    | ~ 10.6µs @ 4GHz |
| Step granularity                  | 20ns            |

</details>

<details>
  <summary><code>boottime</code> (<code>CLOCK_BOOTTIME</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, from an arbitrary point

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | ❌ Yes          |
| Affected by system suspension     | ❌ Yes          |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | ✅ No           |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 25ns @ 4GHz   |
| Cold read cost                    | ~ 11.2µs @ 4GHz |
| Step granularity                  | 20ns            |

</details>

<details>
  <summary><code>boottimeAlarm</code> (<code>CLOCK_BOOTTIME_ALARM</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ❌ Yes         |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 140ns @ 4GHz |
| Cold read cost                    | ~ 4.9µs @ 4GHz |
| Step granularity                  | 140ns          |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures CPU time used by this process

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 165ns @ 4GHz |
| Cold read cost                    | ~ 7µs @ 4GHz   |
| Step granularity                  | 170ns          |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures CPU time used by this thread

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 160ns @ 4GHz |
| Cold read cost                    | ~ 6.5µs @ 4GHz |
| Step granularity                  | 160ns          |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this process spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this process's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this thread spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this thread's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

</details>

<details>
  <summary><b>Windows</b></summary>

<details>
  <summary><code>performanceCounter</code> (<code>QueryPerformanceCounter</code>)</summary>

[QueryPerformanceCounter](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter)

Measures Elapsed time, since the machine started

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 10ns @ 4GHz  |
| Cold read cost                    | ~ 230ns @ 4GHz |
| Step granularity                  | 100ns          |

</details>

<details>
  <summary><code>systemTime</code> (<code>GetSystemTimeAsFileTime</code>)</summary>

[GetSystemTimeAsFileTime](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtimeasfiletime)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | ❌ Yes         |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 2ms       |
| Typical read cost                 | ~ 4ns @ 4GHz   |
| Cold read cost                    | ~ 1.5µs @ 4GHz |
| Step granularity                  | ~ 1ms          |

</details>

<details>
  <summary><code>systemTimePrecise</code> (<code>GetSystemTimePreciseAsFileTime</code>)</summary>

[GetSystemTimePreciseAsFileTime](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtimepreciseasfiletime)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value         |
| --------------------------------- | ------------- |
| Affected by OS clock changes      | ❌ Yes        |
| Affected by NTP changes           | ❌ Yes        |
| Affected by system suspension     | ❌ Yes        |
| Affected by process de-scheduling | ❌ Yes        |
| Appears to go backwards           | ❌ Yes        |
| Reads a cached value              | ✅ No         |
| Possible staleness                | ✅ None       |
| Typical read cost                 | ~ 16ns @ 4GHz |
| Cold read cost                    | ~ 2µs @ 4GHz  |
| Step granularity                  | 100ns         |

</details>

<details>
  <summary><code>interruptTime</code> (<code>QueryInterruptTime</code>)</summary>

[QueryInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttime)

Measures Elapsed time, since the machine started

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 2ms       |
| Typical read cost                 | ~ 2ns @ 4GHz   |
| Cold read cost                    | ~ 1.9µs @ 4GHz |
| Step granularity                  | ~ 1ms          |

</details>

<details>
  <summary><code>interruptTimePrecise</code> (<code>QueryInterruptTimePrecise</code>)</summary>

[QueryInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttimeprecise)

Measures Elapsed time, since the machine started

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 14ns @ 4GHz  |
| Cold read cost                    | ~ 330ns @ 4GHz |
| Step granularity                  | 100ns          |

</details>

<details>
  <summary><code>unbiasedInterruptTime</code> (<code>QueryUnbiasedInterruptTime</code>)</summary>

[QueryUnbiasedInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttime)

Measures Elapsed time, since the machine started

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 2ms       |
| Typical read cost                 | ~ 3ns @ 4GHz   |
| Cold read cost                    | ~ 1.9µs @ 4GHz |
| Step granularity                  | ~ 1ms          |

</details>

<details>
  <summary><code>unbiasedInterruptTimePrecise</code> (<code>QueryUnbiasedInterruptTimePrecise</code>)</summary>

[QueryUnbiasedInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttimeprecise)

Measures Elapsed time, since the machine started

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 14ns @ 4GHz  |
| Cold read cost                    | ~ 280ns @ 4GHz |
| Step granularity                  | 100ns          |

</details>

<details>
  <summary><code>tickCount</code> (<code>GetTickCount64</code>)</summary>

[GetTickCount64](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-gettickcount64)

Measures Elapsed time, since the machine started

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 18ms      |
| Typical read cost                 | ~ 1.5ns @ 4GHz |
| Cold read cost                    | ~ 1.4µs @ 4GHz |
| Step granularity                  | 15ms           |

</details>

<details>
  <summary><code>processTime</code> (<code>GetProcessTimes</code>)</summary>

[GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)

Measures CPU time used by this process

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 15.6ms    |
| Typical read cost                 | ~ 120ns @ 4GHz |
| Cold read cost                    | ~ 2.6µs @ 4GHz |
| Step granularity                  | 15.625ms       |

</details>

<details>
  <summary><code>threadTime</code> (<code>GetThreadTimes</code>)</summary>

[GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)

Measures CPU time used by this thread

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 15.6ms    |
| Typical read cost                 | ~ 86ns @ 4GHz  |
| Cold read cost                    | ~ 585ns @ 4GHz |
| Step granularity                  | 15.625ms       |

</details>

<details>
  <summary><code>processUserTime</code> (<code>GetProcessTimes</code>)</summary>

[GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)

One half of the pair `GetProcessTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time this process spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 15.625ms         |

</details>

<details>
  <summary><code>processKernelTime</code> (<code>GetProcessTimes</code>)</summary>

[GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)

One half of the pair `GetProcessTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time the kernel spent on this process's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 15.625ms         |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>GetThreadTimes</code>)</summary>

[GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)

One half of the pair `GetThreadTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time this thread spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 15.625ms         |

</details>

<details>
  <summary><code>threadKernelTime</code> (<code>GetThreadTimes</code>)</summary>

[GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)

One half of the pair `GetThreadTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time the kernel spent on this thread's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 15.625ms         |

</details>

</details>

<details>
  <summary><b>FreeBSD</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 300ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>realtimePrecise</code> (<code>CLOCK_REALTIME_PRECISE</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 365ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>realtimeFast</code> (<code>CLOCK_REALTIME_FAST</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 265ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 265ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>monotonicPrecise</code> (<code>CLOCK_MONOTONIC_PRECISE</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 265ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>monotonicFast</code> (<code>CLOCK_MONOTONIC_FAST</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 10ms      |
| Typical read cost                 | ~ 3.5ns @ 4GHz |
| Cold read cost                    | ~ 235ns @ 4GHz |
| Step granularity                  | 10ms           |

</details>

<details>
  <summary><code>uptime</code> (<code>CLOCK_UPTIME</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 265ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>uptimePrecise</code> (<code>CLOCK_UPTIME_PRECISE</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 265ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>uptimeFast</code> (<code>CLOCK_UPTIME_FAST</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 10ms      |
| Typical read cost                 | ~ 3.5ns @ 4GHz |
| Cold read cost                    | ~ 265ns @ 4GHz |
| Step granularity                  | 10ms           |

</details>

<details>
  <summary><code>boottime</code> (<code>CLOCK_BOOTTIME</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 395ns @ 4GHz |
| Step granularity                  | 42ns           |

</details>

<details>
  <summary><code>tai</code> (<code>CLOCK_TAI</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, on the TAI timescale

Rejected with `EINVAL` until the machine's TAI offset has been set. Traps on runtime.

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 120ns @ 4GHz |
| Cold read cost                    | ~ 695ns @ 4GHz |
| Step granularity                  | 125ns          |

</details>

<details>
  <summary><code>virtual</code> (<code>CLOCK_VIRTUAL</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this process, user mode only

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 145ns @ 4GHz |
| Cold read cost                    | ~ 495ns @ 4GHz |
| Step granularity                  | 1µs            |

</details>

<details>
  <summary><code>prof</code> (<code>CLOCK_PROF</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this process

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 145ns @ 4GHz |
| Cold read cost                    | ~ 560ns @ 4GHz |
| Step granularity                  | 1µs            |

</details>

<details>
  <summary><code>second</code> (<code>CLOCK_SECOND</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, whole seconds only

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ❌ Yes         |
| Affected by NTP changes           | N/A            |
| Affected by system suspension     | ❌ Yes         |
| Affected by process de-scheduling | ❌ Yes         |
| Appears to go backwards           | ❌ Yes         |
| Reads a cached value              | ❌ Yes         |
| Possible staleness                | ❌ ~ 1s        |
| Typical read cost                 | ~ 18ns @ 4GHz  |
| Cold read cost                    | ~ 265ns @ 4GHz |
| Step granularity                  | 1s             |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this process

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 145ns @ 4GHz |
| Cold read cost                    | ~ 595ns @ 4GHz |
| Step granularity                  | 170ns          |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this thread

| Property                          | Value          |
| --------------------------------- | -------------- |
| Affected by OS clock changes      | ✅ No          |
| Affected by NTP changes           | ✅ No          |
| Affected by system suspension     | ✅ No          |
| Affected by process de-scheduling | ✅ No          |
| Appears to go backwards           | ✅ No          |
| Reads a cached value              | ✅ No          |
| Possible staleness                | ✅ None        |
| Typical read cost                 | ~ 120ns @ 4GHz |
| Cold read cost                    | ~ 495ns @ 4GHz |
| Step granularity                  | 125ns          |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this process spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this process's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this thread spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this thread's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

</details>

<details>
  <summary><b>OpenBSD</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ❌ Yes          |
| Affected by NTP changes           | N/A             |
| Affected by system suspension     | ❌ Yes          |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ❌ Yes          |
| Reads a cached value              | N/A             |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 21ns @ 4GHz   |
| Cold read cost                    | ~ 19.7µs @ 4GHz |
| Step granularity                  | 42ns            |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Elapsed time, from an arbitrary point

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | N/A             |
| Affected by system suspension     | N/A             |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | N/A             |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 20ns @ 4GHz   |
| Cold read cost                    | ~ 21.9µs @ 4GHz |
| Step granularity                  | 42ns            |

</details>

<details>
  <summary><code>boottime</code> (<code>CLOCK_BOOTTIME</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Elapsed time, since the machine booted

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | N/A             |
| Affected by system suspension     | ❌ Yes          |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | N/A             |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 20ns @ 4GHz   |
| Cold read cost                    | ~ 18.2µs @ 4GHz |
| Step granularity                  | 42ns            |

</details>

<details>
  <summary><code>uptime</code> (<code>CLOCK_UPTIME</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Elapsed time, since the machine booted

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | N/A             |
| Affected by system suspension     | ✅ No           |
| Affected by process de-scheduling | ❌ Yes          |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | N/A             |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 20ns @ 4GHz   |
| Cold read cost                    | ~ 15.9µs @ 4GHz |
| Step granularity                  | 42ns            |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures CPU time used by this process

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | ✅ No           |
| Affected by system suspension     | ✅ No           |
| Affected by process de-scheduling | ✅ No           |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | N/A             |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 235ns @ 4GHz  |
| Cold read cost                    | ~ 15.4µs @ 4GHz |
| Step granularity                  | 291ns           |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures CPU time used by this thread

| Property                          | Value           |
| --------------------------------- | --------------- |
| Affected by OS clock changes      | ✅ No           |
| Affected by NTP changes           | ✅ No           |
| Affected by system suspension     | ✅ No           |
| Affected by process de-scheduling | ✅ No           |
| Appears to go backwards           | ✅ No           |
| Reads a cached value              | N/A             |
| Possible staleness                | ✅ None         |
| Typical read cost                 | ~ 195ns @ 4GHz  |
| Cold read cost                    | ~ 15.5µs @ 4GHz |
| Step granularity                  | 125ns           |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this process spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this process's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time this thread spent running its own code

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

Not a clock id the platform declares: this library's own, selecting one half of one call.

Measures CPU time the kernel spent on this thread's behalf

| Property                          | Value            |
| --------------------------------- | ---------------- |
| Affected by OS clock changes      | ✅ No            |
| Affected by NTP changes           | ✅ No            |
| Affected by system suspension     | ✅ No            |
| Affected by process de-scheduling | ✅ No            |
| Appears to go backwards           | ✅ No            |
| Reads a cached value              | ✅ No            |
| Possible staleness                | ✅ None          |
| Typical read cost                 | Not yet measured |
| Cold read cost                    | Not yet measured |
| Step granularity                  | 1µs              |

</details>

</details>

<details>
  <summary><b>WASI</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[WASI preview1](https://github.com/WebAssembly/WASI/blob/snapshot-01/phases/snapshot/docs.md)

Measures Wall time, counted from 1970-01-01 UTC

| Property                          | Value         |
| --------------------------------- | ------------- |
| Affected by OS clock changes      | N/A           |
| Affected by NTP changes           | N/A           |
| Affected by system suspension     | N/A           |
| Affected by process de-scheduling | ❌ Yes        |
| Appears to go backwards           | N/A           |
| Reads a cached value              | N/A           |
| Possible staleness                | ✅ None       |
| Typical read cost                 | ~ 57ns @ 4GHz |
| Cold read cost                    | N/A           |
| Step granularity                  | 1µs           |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[WASI preview1](https://github.com/WebAssembly/WASI/blob/snapshot-01/phases/snapshot/docs.md)

Measures Elapsed time, from an arbitrary point

| Property                          | Value         |
| --------------------------------- | ------------- |
| Affected by OS clock changes      | ✅ No         |
| Affected by NTP changes           | ✅ No         |
| Affected by system suspension     | N/A           |
| Affected by process de-scheduling | ❌ Yes        |
| Appears to go backwards           | ✅ No         |
| Reads a cached value              | N/A           |
| Possible staleness                | ✅ None       |
| Typical read cost                 | ~ 56ns @ 4GHz |
| Cold read cost                    | N/A           |
| Step granularity                  | 42ns          |

</details>

</details>

## Performance

* Below are benchmarks of this library against the 2 clocks that Swift standard library provides, on macOS and Linux.
  * That is, `SystemClock`'s `.continuous`/`.suspending` vs. stdlib's `ContinuousClock`/`SuspendingClock`.
  * The instruction tables contain most other clocks supported by `SystemClock` as well for comparison.
* **In all cases, swift-system-clock wins against the Swift standard library APIs.**
* `N/A` means unsupported clock.

### Against Darwin

These were performed on my M1 Pro MacBook, on macOS 27.

| Benchmark        | `SystemClock` (ns/op) | Standard Library (ns/op) | Speedup |
| ---------------- | --------------------- | ------------------------ | ------- |
| `continuous.now` | 10.6 ns               | 24.9 ns                  | 2.35x   |
| `suspending.now` | 10.8 ns               | 24.3 ns                  | 2.25x   |

| Benchmark              | `SystemClock` instructions | Standard Library instructions |
| ---------------------- | -------------------------- | ----------------------------- |
| `realtime.now`         | 145                        | N/A                           |
| `realtimeCoarse.now`   | 145                        | N/A                           |
| `continuous.now`       | 93                         | 205                           |
| `continuousCoarse.now` | 103                        | N/A                           |
| `suspending.now`       | 100                        | 210                           |
| `suspendingCoarse.now` | 90                         | N/A                           |
| `processCPUTime.now`   | 3182                       | N/A                           |
| `threadCPUTime.now`    | 1547                       | N/A                           |

### Against glibc

These were performed on a dedicated-cpu-core AMD EPYC-Milan VM from Hetzner, on Ubuntu 24.04.

| Benchmark        | `SystemClock` (ns/op) | Standard Library (ns/op) | Speedup |
| ---------------- | --------------------- | ------------------------ | ------- |
| `continuous.now` | 26.8 ns               | 29.8 ns                  | 1.11x   |
| `suspending.now` | 26.8 ns               | 29.5 ns                  | 1.10x   |

| Benchmark              | `SystemClock` instructions | Standard Library instructions |
| ---------------------- | -------------------------- | ----------------------------- |
| `realtime.now`         | 133                        | N/A                           |
| `realtimeCoarse.now`   | 87                         | N/A                           |
| `continuous.now`       | 133                        | 200                           |
| `continuousCoarse.now` | 133                        | N/A                           |
| `suspending.now`       | 133                        | 198                           |
| `suspendingCoarse.now` | 87                         | N/A                           |
| `processCPUTime.now`   | 79                         | N/A                           |
| `threadCPUTime.now`    | 79                         | N/A                           |

#### Additional Notes

* To see up to date information about performance of this package, please go to this [benchmarks list](https://github.com/swift-dns/swift-system-clock/actions/workflows/benchmarks.yml?query=branch%3Amain), and choose the most recent benchmark. You'll see a summary of the benchmark there.
* The results above are all reproducible by simply running `scripts/benchmark.sh` on a machine of your own.
