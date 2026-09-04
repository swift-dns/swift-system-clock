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

Supports `Darwin` (`Apple` platforms), `Linux` (Including `Android`), `Windows`, `FreeBSD`, `OpenBSD`[^1], `WASI` and more.   
Also compiles (merely) on embedded platforms in a similar fashion to Swift standard library's `ContinuousClock`.

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
    wasi: .realtime,
    fallback: .realtime
)

/// You can use `Swift.Duration` as well although `CompactDuration` is generally recommended.
let processCPUTimeClock = GenericSystemClock<Swift.Duration>(
    darwin: .processCPUTime,
    linux: .processCPUTime,
    windows: .processTime,
    freebsd: .processCPUTime,
    openbsd: .processCPUTime,
    wasi: .monotonic,
    fallback: .monotonic
)
```

Every Apple platform takes `darwin`. Android takes `linux`.   
Unidentified platforms or platforms with no libc will take `fallback` which uses `std::chrono` clocks.

> [!NOTE]
> `SystemClock` will only compile code for the platform you're deploying to.   
> Essentially, `SystemClock` is a multi-platform library, but that comes for free with no overhead.

### Sleeping

> [!WARNING]
> `SystemClock` does not support sleeping.   
> `sleep(until:tolerance:)` only exists as a requirement of the `Clock` protocol, and fatal-errors when called.   
> `Task.sleep(for:clock:)` and `Task.sleep(until:clock:)` route through it, so they'll crash too.   
> Use standard library's `ContinuousClock` or `SuspendingClock` instead for sleeping.

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
> On `WASI`, wasi-libc exposes 2 clocks only: `monotonic` and `realtime`.   
> When a clock is unavailable on any platform, `SystemClock` simply falls back to the best available fit.

## Platform Clocks

* This library supports every clock Unix systems expose via [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html).
* For Windows, this library follows [Acquiring high-resolution time stamps](https://learn.microsoft.com/en-us/windows/win32/sysinfo/acquiring-high-resolution-time-stamps).
* In few cases, for example for `processUserTime` and `threadUserTime`, this library uses alternative functions such as [getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html).

### Supported Clocks

Here is a list of all supported clocks on each platform.

* `macOS` was measured on an M1 Pro (arm64 Apple silicon) under macOS 27, bare metal.
* `Windows` on an Intel Core i7-10750H (x86_64) under Windows 11, bare metal.
* `Linux` on Ubuntu 24.04 (kernel 6.8, `HZ=1000`) in a dedicated-core AMD EPYC Milan x86_64 VM from Hetzner.
* `FreeBSD` 15.1 and `OpenBSD` 7.9 in arm64 QEMU virtual machines on the same Mac, where `kern.hz` is 100.
* `WASI` on the same Mac under wasmtime 48 (primary source), Node 26 (uvwasi), Bun 1.3 and WasmKit 0.1.6.

> [!NOTE]
> The measured values are meant as general hints.     
> For better accuracy, measure under your own specific hardware and kernel.   
> If you find a value generally/widely incorrect, please file an issue or open a pull request for it.

| Clock                          | Darwin | Linux | Windows | FreeBSD | OpenBSD | WASI | Fallback |
| ------------------------------ | ------ | ----- | ------- | ------- | ------- | ---- | -------- |
| `realtime`                     | ✅     | ✅     |         | ✅      | ✅      | ✅    | ✅        |
| `realtimePrecise`              |        |       |         | ✅       |         |      |          |
| `realtimeFast`                 |        |       |         | ✅       |         |      |          |
| `realtimeCoarse`               |        | ✅     |         |         |         |      |          |
| `realtimeAlarm`                |        | ✅     |         |         |         |      |          |
| `systemTime`                   |        |       | ✅       |         |         |      |          |
| `systemTimePrecise`            |        |       | ✅       |         |         |      |          |
| `second`                       |        |       |         | ✅       |         |      |          |
| `tai`                          |        | ✅     |         | ✅       |        |      |          |
| `monotonic`                    | ✅     | ✅     |         | ✅      | ✅      | ✅    | ✅        |
| `monotonicPrecise`             |        |       |         | ✅       |         |      |          |
| `monotonicFast`                |        |       |         | ✅       |         |      |          |
| `monotonicCoarse`              |        | ✅     |         |         |         |      |          |
| `monotonicRaw`                 | ✅     | ✅     |         |         |         |      |          |
| `monotonicRawApproximate`      | ✅     |        |         |         |         |      |          |
| `performanceCounter`           |        |       | ✅       |         |         |      |          |
| `interruptTime`                |        |       | ✅       |         |         |      |          |
| `interruptTimePrecise`         |        |       | ✅       |         |         |      |          |
| `unbiasedInterruptTime`        |        |       | ✅       |         |         |      |          |
| `unbiasedInterruptTimePrecise` |        |       | ✅       |         |         |      |          |
| `tickCount`                    |        |       | ✅       |         |         |      |          |
| `boottime`                     |        | ✅     |         | ✅       | ✅      |      |          |
| `boottimeAlarm`                |        | ✅     |         |         |         |      |          |
| `uptime`                       |        |       |         | ✅       | ✅      |      |          |
| `uptimePrecise`                |        |       |         | ✅       |         |      |          |
| `uptimeFast`                   |        |       |         | ✅       |         |      |          |
| `uptimeRaw`                    | ✅     |        |         |         |         |      |          |
| `uptimeRawApproximate`         | ✅     |        |         |         |         |      |          |
| `processCPUTime`               | ✅     | ✅     |         | ✅       | ✅      |      |          |
| `processTime`                  |        |       | ✅       |         |         |      |          |
| `threadCPUTime`                | ✅     | ✅     |         | ✅       | ✅      |      |          |
| `threadTime`                   |        |       | ✅       |         |         |      |          |
| `processUserTime`              | ✅     | ✅     | ✅      | ✅       | ✅      |      |          |
| `processSystemTime`            | ✅     | ✅     |         | ✅       | ✅      |      |          |
| `processKernelTime`            |        |       | ✅       |         |         |      |          |
| `threadUserTime`               | ✅     | ✅     | ✅      | ✅       | ✅      |      |          |
| `threadSystemTime`             | ✅     | ✅     |         | ✅       | ✅      |      |          |
| `threadKernelTime`             |        |       | ✅       |         |         |      |          |
| `virtual`                      |        |       |         | ✅       |         |      |          |
| `prof`                         |        |       |         | ✅       |         |      |          |
| `highResolution`               |        |       |         |         |         |      | ✅        |

<details>
  <summary><b>Darwin (Apple platforms)</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ❌ Yes         |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ❌ Yes         |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 12ns @ 4GHz  |
| Cold read cost                        | ~ 200ns @ 4GHz |
| Step granularity                      | 1µs            |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 17ns @ 4GHz  |
| Cold read cost                        | ~ 165ns @ 4GHz |
| Step granularity                      | 1µs            |

</details>

<details>
  <summary><code>monotonicRaw</code> (<code>CLOCK_MONOTONIC_RAW</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 13ns @ 4GHz  |
| Cold read cost                        | ~ 135ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>monotonicRawApproximate</code> (<code>CLOCK_MONOTONIC_RAW_APPROX</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ❌ Yes         |
| Max staleness                         | ❌ ~ 0.5-2ms   |
| Warm read cost                        | ~ 5.5ns @ 4GHz |
| Cold read cost                        | ~ 230ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>uptimeRaw</code> (<code>CLOCK_UPTIME_RAW</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 13ns @ 4GHz  |
| Cold read cost                        | ~ 165ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>uptimeRawApproximate</code> (<code>CLOCK_UPTIME_RAW_APPROX</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ❌ Yes         |
| Max staleness                         | ❌ ~ 0.5-2ms   |
| Warm read cost                        | ~ 5ns @ 4GHz   |
| Cold read cost                        | ~ 165ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures CPU time used by this process

| Property                               | Value                               |
| -------------------------------------- | ----------------------------------- |
| Reacts to OS time changes              | ✅ No                               |
| Reacts to NTP changes                  | ✅ No                               |
| Counts system suspension times         | ✅ No                               |
| Advances while process is de-scheduled | ✅ No                               |
| Might appear to go backwards           | ✅ No                               |
| Reads a cached value                   | ❌ Yes, for other threads           |
| Max staleness                          | ❌ ~ 10ms, from other threads       |
| Warm read cost                         | ~ 210ns + up to ~ 8ns/thread @ 4GHz |
| Cold read cost                         | ~ 1.3µs @ 4GHz                      |
| Step granularity                       | 1µs                                 |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)

Measures CPU time used by this thread

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ✅ No          |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 115ns @ 4GHz |
| Cold read cost                        | ~ 460ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://keith.github.io/xcode-man-pages/getrusage.2.html)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this process spent running its own code

| Property                               | Value                               |
| -------------------------------------- | ----------------------------------- |
| Reacts to OS time changes              | ✅ No                               |
| Reacts to NTP changes                  | ✅ No                               |
| Counts system suspension times         | ✅ No                               |
| Advances while process is de-scheduled | ✅ No                               |
| Might appear to go backwards           | ✅ No                               |
| Reads a cached value                   | ❌ Yes, for other threads           |
| Max staleness                          | ❌ ~ 10ms, from other threads       |
| Warm read cost                         | ~ 210ns + up to ~ 8ns/thread @ 4GHz |
| Cold read cost                         | ~ 4.3µs @ 4GHz                      |
| Step granularity                       | 1µs                                 |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://keith.github.io/xcode-man-pages/getrusage.2.html)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this process's behalf

| Property                               | Value                               |
| -------------------------------------- | ----------------------------------- |
| Reacts to OS time changes              | ✅ No                               |
| Reacts to NTP changes                  | ✅ No                               |
| Counts system suspension times         | ✅ No                               |
| Advances while process is de-scheduled | ✅ No                               |
| Might appear to go backwards           | ✅ No                               |
| Reads a cached value                   | ❌ Yes, for other threads           |
| Max staleness                          | ❌ ~ 10ms, from other threads       |
| Warm read cost                         | ~ 210ns + up to ~ 8ns/thread @ 4GHz |
| Cold read cost                         | ~ 4.5µs @ 4GHz                      |
| Step granularity                       | 1µs                                 |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>THREAD_BASIC_INFO</code>)</summary>

[thread_info](https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/mach/thread_act.defs)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this thread spent running its own code

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ✅ No          |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 460ns @ 4GHz |
| Cold read cost                        | ~ 5.8µs @ 4GHz |
| Step granularity                      | 1µs            |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>THREAD_BASIC_INFO</code>)</summary>

[thread_info](https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/mach/thread_act.defs)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this thread's behalf

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ✅ No          |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 460ns @ 4GHz |
| Cold read cost                        | ~ 5.2µs @ 4GHz |
| Step granularity                      | 1µs            |

</details>

</details>

<details>
  <summary><b>Linux (Including Android)</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ❌ Yes          |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ❌ Yes          |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ❌ Yes          |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 25ns @ 4GHz   |
| Cold read cost                        | ~ 10.6µs @ 4GHz |
| Step granularity                      | 20ns            |

</details>

<details>
  <summary><code>realtimeAlarm</code> (<code>CLOCK_REALTIME_ALARM</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ❌ Yes         |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ❌ Yes         |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 135ns @ 4GHz |
| Cold read cost                        | ~ 4.6µs @ 4GHz |
| Step granularity                      | 140ns          |

</details>

<details>
  <summary><code>realtimeCoarse</code> (<code>CLOCK_REALTIME_COARSE</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value              |
| ------------------------------------- | ------------------ |
| Reacts to OS time changes             | ❌ Yes             |
| Reacts to NTP changes                 | ❌ Yes             |
| Counts system suspension times        | ❌ Yes             |
| Advances while thread is de-scheduled | ❌ Yes             |
| Might appear to go backwards          | ❌ Yes             |
| Reads a cached value                  | ❌ Yes             |
| Max staleness                         | ❌ ~ 1ms @ HZ 1000 |
| Warm read cost                        | ~ 4.5ns @ 4GHz     |
| Cold read cost                        | ~ 9µs @ 4GHz       |
| Step granularity                      | 1ms @ HZ 1000      |

</details>

<details>
  <summary><code>tai</code> (<code>CLOCK_TAI</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Wall time, on the TAI timescale

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ❌ Yes          |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ❌ Yes          |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ❌ Yes          |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 25ns @ 4GHz   |
| Cold read cost                        | ~ 10.8µs @ 4GHz |
| Step granularity                      | 20ns            |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, since the machine booted

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ✅ No           |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ✅ No           |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ✅ No           |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 25ns @ 4GHz   |
| Cold read cost                        | ~ 10.8µs @ 4GHz |
| Step granularity                      | 20ns            |

</details>

<details>
  <summary><code>monotonicCoarse</code> (<code>CLOCK_MONOTONIC_COARSE</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, since the machine booted

| Property                              | Value              |
| ------------------------------------- | ------------------ |
| Reacts to OS time changes             | ✅ No              |
| Reacts to NTP changes                 | ❌ Yes             |
| Counts system suspension times        | ✅ No              |
| Advances while thread is de-scheduled | ❌ Yes             |
| Might appear to go backwards          | ✅ No              |
| Reads a cached value                  | ❌ Yes             |
| Max staleness                         | ❌ ~ 1ms @ HZ 1000 |
| Warm read cost                        | ~ 4.5ns @ 4GHz     |
| Cold read cost                        | ~ 9µs @ 4GHz       |
| Step granularity                      | 1ms @ HZ 1000      |

</details>

<details>
  <summary><code>monotonicRaw</code> (<code>CLOCK_MONOTONIC_RAW</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, since the machine booted

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ✅ No           |
| Reacts to NTP changes                 | ✅ No           |
| Counts system suspension times        | ✅ No           |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ✅ No           |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 25ns @ 4GHz   |
| Cold read cost                        | ~ 10.6µs @ 4GHz |
| Step granularity                      | 20ns            |

</details>

<details>
  <summary><code>boottime</code> (<code>CLOCK_BOOTTIME</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, since the machine booted

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ✅ No           |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ❌ Yes          |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ✅ No           |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 25ns @ 4GHz   |
| Cold read cost                        | ~ 11.2µs @ 4GHz |
| Step granularity                      | 20ns            |

</details>

<details>
  <summary><code>boottimeAlarm</code> (<code>CLOCK_BOOTTIME_ALARM</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures Elapsed time, since the machine booted

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 140ns @ 4GHz |
| Cold read cost                        | ~ 4.9µs @ 4GHz |
| Step granularity                      | 140ns          |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures CPU time used by this process

| Property                               | Value                                  |
| -------------------------------------- | -------------------------------------- |
| Reacts to OS time changes              | ✅ No                                  |
| Reacts to NTP changes                  | ✅ No                                  |
| Counts system suspension times         | ✅ No                                  |
| Advances while process is de-scheduled | ✅ No                                  |
| Might appear to go backwards           | ✅ No                                  |
| Reads a cached value                   | ❌ Yes, for other threads              |
| Max staleness                          | ❌ ~ 1ms @ HZ 1000, from other threads |
| Warm read cost                         | ~ 165ns + ~ 6ns/thread @ 4GHz          |
| Cold read cost                         | ~ 7µs @ 4GHz                           |
| Step granularity                       | 170ns                                  |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

Measures CPU time used by this thread

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ✅ No          |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 160ns @ 4GHz |
| Cold read cost                        | ~ 6.5µs @ 4GHz |
| Step granularity                      | 160ns          |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this process spent running its own code

| Property                               | Value                                  |
| -------------------------------------- | -------------------------------------- |
| Reacts to OS time changes              | ✅ No                                  |
| Reacts to NTP changes                  | ✅ No                                  |
| Counts system suspension times         | ✅ No                                  |
| Advances while process is de-scheduled | ✅ No                                  |
| Might appear to go backwards           | ✅ No                                  |
| Reads a cached value                   | ❌ Yes, for other threads              |
| Max staleness                          | ❌ ~ 1ms @ HZ 1000, from other threads |
| Warm read cost                         | ~ 220ns + ~ 12ns/thread @ 4GHz         |
| Cold read cost                         | ~ 4µs @ 4GHz                           |
| Step granularity                       | 1µs                                    |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this process's behalf

| Property                               | Value                                  |
| -------------------------------------- | -------------------------------------- |
| Reacts to OS time changes              | ✅ No                                  |
| Reacts to NTP changes                  | ✅ No                                  |
| Counts system suspension times         | ✅ No                                  |
| Advances while process is de-scheduled | ✅ No                                  |
| Might appear to go backwards           | ✅ No                                  |
| Reads a cached value                   | ❌ Yes, for other threads              |
| Max staleness                          | ❌ ~ 1ms @ HZ 1000, from other threads |
| Warm read cost                         | ~ 220ns + ~ 12ns/thread @ 4GHz         |
| Cold read cost                         | ~ 3.5µs @ 4GHz                         |
| Step granularity                       | 1µs                                    |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this thread spent running its own code

| Property                              | Value              |
| ------------------------------------- | ------------------ |
| Reacts to OS time changes             | ✅ No              |
| Reacts to NTP changes                 | ✅ No              |
| Counts system suspension times        | ✅ No              |
| Advances while thread is de-scheduled | ✅ No              |
| Might appear to go backwards          | ✅ No              |
| Reads a cached value                  | ❌ Yes             |
| Max staleness                         | ❌ ~ 1ms @ HZ 1000 |
| Warm read cost                        | ~ 150ns @ 4GHz     |
| Cold read cost                        | ~ 3.1µs @ 4GHz     |
| Step granularity                      | ~ 1ms @ HZ 1000    |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this thread's behalf

| Property                              | Value              |
| ------------------------------------- | ------------------ |
| Reacts to OS time changes             | ✅ No              |
| Reacts to NTP changes                 | ✅ No              |
| Counts system suspension times        | ✅ No              |
| Advances while thread is de-scheduled | ✅ No              |
| Might appear to go backwards          | ✅ No              |
| Reads a cached value                  | ❌ Yes             |
| Max staleness                         | ❌ ~ 1ms @ HZ 1000 |
| Warm read cost                        | ~ 150ns @ 4GHz     |
| Cold read cost                        | ~ 2.7µs @ 4GHz     |
| Step granularity                      | ~ 1ms @ HZ 1000    |

</details>

</details>

<details>
  <summary><b>Windows</b></summary>

<details>
  <summary><code>performanceCounter</code> (<code>QueryPerformanceCounter</code>)</summary>

[QueryPerformanceCounter](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter)

Measures Elapsed time, since the machine booted

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 10ns @ 4GHz  |
| Cold read cost                        | ~ 230ns @ 4GHz |
| Step granularity                      | 100ns          |

</details>

<details>
  <summary><code>systemTime</code> (<code>GetSystemTimeAsFileTime</code>)</summary>

[GetSystemTimeAsFileTime](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtimeasfiletime)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value                 |
| ------------------------------------- | --------------------- |
| Reacts to OS time changes             | ❌ Yes                |
| Reacts to NTP changes                 | ❌ Yes                |
| Counts system suspension times        | ❌ Yes                |
| Advances while thread is de-scheduled | ❌ Yes                |
| Might appear to go backwards          | ❌ Yes                |
| Reads a cached value                  | ❌ Yes                |
| Max staleness                         | ❌ ~ 16ms @ 64Hz tick |
| Warm read cost                        | ~ 4ns @ 4GHz          |
| Cold read cost                        | ~ 1.5µs @ 4GHz        |
| Step granularity                      | ~ 0.5ms               |

</details>

<details>
  <summary><code>systemTimePrecise</code> (<code>GetSystemTimePreciseAsFileTime</code>)</summary>

[GetSystemTimePreciseAsFileTime](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtimepreciseasfiletime)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value         |
| ------------------------------------- | ------------- |
| Reacts to OS time changes             | ❌ Yes        |
| Reacts to NTP changes                 | ❌ Yes        |
| Counts system suspension times        | ❌ Yes        |
| Advances while thread is de-scheduled | ❌ Yes        |
| Might appear to go backwards          | ❌ Yes        |
| Reads a cached value                  | ✅ No         |
| Max staleness                         | ✅ None       |
| Warm read cost                        | ~ 16ns @ 4GHz |
| Cold read cost                        | ~ 2µs @ 4GHz  |
| Step granularity                      | 100ns         |

</details>

<details>
  <summary><code>interruptTime</code> (<code>QueryInterruptTime</code>)</summary>

[QueryInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttime)

Measures Elapsed time, since the machine booted

| Property                              | Value                 |
| ------------------------------------- | --------------------- |
| Reacts to OS time changes             | ✅ No                 |
| Reacts to NTP changes                 | ✅ No                 |
| Counts system suspension times        | ❌ Yes                |
| Advances while thread is de-scheduled | ❌ Yes                |
| Might appear to go backwards          | ✅ No                 |
| Reads a cached value                  | ❌ Yes                |
| Max staleness                         | ❌ ~ 16ms @ 64Hz tick |
| Warm read cost                        | ~ 2ns @ 4GHz          |
| Cold read cost                        | ~ 1.9µs @ 4GHz        |
| Step granularity                      | ~ 0.5ms               |

</details>

<details>
  <summary><code>interruptTimePrecise</code> (<code>QueryInterruptTimePrecise</code>)</summary>

[QueryInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttimeprecise)

Measures Elapsed time, since the machine booted

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 14ns @ 4GHz  |
| Cold read cost                        | ~ 330ns @ 4GHz |
| Step granularity                      | 100ns          |

</details>

<details>
  <summary><code>unbiasedInterruptTime</code> (<code>QueryUnbiasedInterruptTime</code>)</summary>

[QueryUnbiasedInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttime)

Measures Elapsed time, since the machine booted

| Property                              | Value                 |
| ------------------------------------- | --------------------- |
| Reacts to OS time changes             | ✅ No                 |
| Reacts to NTP changes                 | ✅ No                 |
| Counts system suspension times        | ✅ No                 |
| Advances while thread is de-scheduled | ❌ Yes                |
| Might appear to go backwards          | ✅ No                 |
| Reads a cached value                  | ❌ Yes                |
| Max staleness                         | ❌ ~ 16ms @ 64Hz tick |
| Warm read cost                        | ~ 3ns @ 4GHz          |
| Cold read cost                        | ~ 1.9µs @ 4GHz        |
| Step granularity                      | ~ 0.5ms               |

</details>

<details>
  <summary><code>unbiasedInterruptTimePrecise</code> (<code>QueryUnbiasedInterruptTimePrecise</code>)</summary>

[QueryUnbiasedInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttimeprecise)

Measures Elapsed time, since the machine booted

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 14ns @ 4GHz  |
| Cold read cost                        | ~ 2.3µs @ 4GHz |
| Step granularity                      | 100ns          |

</details>

<details>
  <summary><code>tickCount</code> (<code>GetTickCount64</code>)</summary>

[GetTickCount64](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-gettickcount64)

Measures Elapsed time, since the machine booted

| Property                              | Value                 |
| ------------------------------------- | --------------------- |
| Reacts to OS time changes             | ✅ No                 |
| Reacts to NTP changes                 | ✅ No                 |
| Counts system suspension times        | ❌ Yes                |
| Advances while thread is de-scheduled | ❌ Yes                |
| Might appear to go backwards          | ✅ No                 |
| Reads a cached value                  | ❌ Yes                |
| Max staleness                         | ❌ ~ 18ms @ 64Hz tick |
| Warm read cost                        | ~ 1.5ns @ 4GHz        |
| Cold read cost                        | ~ 1.8µs @ 4GHz        |
| Step granularity                      | 15ms                  |

</details>

<details>
  <summary><code>processTime</code> (<code>GetProcessTimes</code>)</summary>

[GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)

Measures CPU time used by this process

| Property                               | Value                                     |
| -------------------------------------- | ----------------------------------------- |
| Reacts to OS time changes              | ✅ No                                     |
| Reacts to NTP changes                  | ✅ No                                     |
| Counts system suspension times         | ✅ No                                     |
| Advances while process is de-scheduled | ✅ No                                     |
| Might appear to go backwards           | ✅ No                                     |
| Reads a cached value                   | ❌ Yes, for all threads                   |
| Max staleness                          | ❌ ~ 15.6ms @ 64Hz tick, from all threads |
| Warm read cost                         | ~ 120ns + up to ~ 8ns/thread @ 4GHz       |
| Cold read cost                         | ~ 2.6µs @ 4GHz                            |
| Step granularity                       | 15.625ms @ 64Hz tick                      |

</details>

<details>
  <summary><code>threadTime</code> (<code>GetThreadTimes</code>)</summary>

[GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)

Measures CPU time used by this thread

| Property                              | Value                   |
| ------------------------------------- | ----------------------- |
| Reacts to OS time changes             | ✅ No                   |
| Reacts to NTP changes                 | ✅ No                   |
| Counts system suspension times        | ✅ No                   |
| Advances while thread is de-scheduled | ✅ No                   |
| Might appear to go backwards          | ✅ No                   |
| Reads a cached value                  | ❌ Yes                  |
| Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick |
| Warm read cost                        | ~ 86ns @ 4GHz           |
| Cold read cost                        | ~ 585ns @ 4GHz          |
| Step granularity                      | 15.625ms @ 64Hz tick    |

</details>

<details>
  <summary><code>processUserTime</code> (<code>GetProcessTimes</code>)</summary>

[GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)

One half of the pair `GetProcessTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time this process spent running its own code

| Property                               | Value                                     |
| -------------------------------------- | ----------------------------------------- |
| Reacts to OS time changes              | ✅ No                                     |
| Reacts to NTP changes                  | ✅ No                                     |
| Counts system suspension times         | ✅ No                                     |
| Advances while process is de-scheduled | ✅ No                                     |
| Might appear to go backwards           | ✅ No                                     |
| Reads a cached value                   | ❌ Yes, for all threads                   |
| Max staleness                          | ❌ ~ 15.6ms @ 64Hz tick, from all threads |
| Warm read cost                         | ~ 113ns + up to ~ 8ns/thread @ 4GHz       |
| Cold read cost                         | ~ 2.7µs @ 4GHz                            |
| Step granularity                       | 15.625ms @ 64Hz tick                      |

</details>

<details>
  <summary><code>processKernelTime</code> (<code>GetProcessTimes</code>)</summary>

[GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)

One half of the pair `GetProcessTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time the kernel spent on this process's behalf

| Property                               | Value                                     |
| -------------------------------------- | ----------------------------------------- |
| Reacts to OS time changes              | ✅ No                                     |
| Reacts to NTP changes                  | ✅ No                                     |
| Counts system suspension times         | ✅ No                                     |
| Advances while process is de-scheduled | ✅ No                                     |
| Might appear to go backwards           | ✅ No                                     |
| Reads a cached value                   | ❌ Yes, for all threads                   |
| Max staleness                          | ❌ ~ 15.6ms @ 64Hz tick, from all threads |
| Warm read cost                         | ~ 115ns + up to ~ 8ns/thread @ 4GHz       |
| Cold read cost                         | ~ 2.8µs @ 4GHz                            |
| Step granularity                       | 15.625ms @ 64Hz tick                      |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>GetThreadTimes</code>)</summary>

[GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)

One half of the pair `GetThreadTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time this thread spent running its own code

| Property                              | Value                   |
| ------------------------------------- | ----------------------- |
| Reacts to OS time changes             | ✅ No                   |
| Reacts to NTP changes                 | ✅ No                   |
| Counts system suspension times        | ✅ No                   |
| Advances while thread is de-scheduled | ✅ No                   |
| Might appear to go backwards          | ✅ No                   |
| Reads a cached value                  | ❌ Yes                  |
| Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick |
| Warm read cost                        | ~ 87ns @ 4GHz           |
| Cold read cost                        | ~ 610ns @ 4GHz          |
| Step granularity                      | 15.625ms @ 64Hz tick    |

</details>

<details>
  <summary><code>threadKernelTime</code> (<code>GetThreadTimes</code>)</summary>

[GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)

One half of the pair `GetThreadTimes` reports; `processTime` and `threadTime` read them summed.

Measures CPU time the kernel spent on this thread's behalf

| Property                              | Value                   |
| ------------------------------------- | ----------------------- |
| Reacts to OS time changes             | ✅ No                   |
| Reacts to NTP changes                 | ✅ No                   |
| Counts system suspension times        | ✅ No                   |
| Advances while thread is de-scheduled | ✅ No                   |
| Might appear to go backwards          | ✅ No                   |
| Reads a cached value                  | ❌ Yes                  |
| Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick |
| Warm read cost                        | ~ 87ns @ 4GHz           |
| Cold read cost                        | ~ 630ns @ 4GHz          |
| Step granularity                      | 15.625ms @ 64Hz tick    |

</details>

</details>

<details>
  <summary><b>FreeBSD</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ❌ Yes         |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ❌ Yes         |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 300ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>realtimePrecise</code> (<code>CLOCK_REALTIME_PRECISE</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ❌ Yes         |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ❌ Yes         |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 365ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>realtimeFast</code> (<code>CLOCK_REALTIME_FAST</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ❌ Yes         |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ❌ Yes         |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 265ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 265ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>monotonicPrecise</code> (<code>CLOCK_MONOTONIC_PRECISE</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 265ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>monotonicFast</code> (<code>CLOCK_MONOTONIC_FAST</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value                   |
| ------------------------------------- | ----------------------- |
| Reacts to OS time changes             | ✅ No                   |
| Reacts to NTP changes                 | ❌ Yes                  |
| Counts system suspension times        | ✅ No                   |
| Advances while thread is de-scheduled | ❌ Yes                  |
| Might appear to go backwards          | ✅ No                   |
| Reads a cached value                  | ❌ Yes                  |
| Max staleness                         | ❌ ~ 1ms @ kern.hz 1000 |
| Warm read cost                        | ~ 3.5ns @ 4GHz          |
| Cold read cost                        | ~ 235ns @ 4GHz          |
| Step granularity                      | 1ms @ kern.hz 1000      |

</details>

<details>
  <summary><code>uptime</code> (<code>CLOCK_UPTIME</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 265ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>uptimePrecise</code> (<code>CLOCK_UPTIME_PRECISE</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 265ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>uptimeFast</code> (<code>CLOCK_UPTIME_FAST</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value                   |
| ------------------------------------- | ----------------------- |
| Reacts to OS time changes             | ✅ No                   |
| Reacts to NTP changes                 | ❌ Yes                  |
| Counts system suspension times        | ✅ No                   |
| Advances while thread is de-scheduled | ❌ Yes                  |
| Might appear to go backwards          | ✅ No                   |
| Reads a cached value                  | ❌ Yes                  |
| Max staleness                         | ❌ ~ 1ms @ kern.hz 1000 |
| Warm read cost                        | ~ 3.5ns @ 4GHz          |
| Cold read cost                        | ~ 265ns @ 4GHz          |
| Step granularity                      | 1ms @ kern.hz 1000      |

</details>

<details>
  <summary><code>boottime</code> (<code>CLOCK_BOOTTIME</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 395ns @ 4GHz |
| Step granularity                      | 42ns           |

</details>

<details>
  <summary><code>tai</code> (<code>CLOCK_TAI</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, on the TAI timescale

Rejected with `EINVAL` until the machine's TAI offset has been set. Traps on runtime.

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ❌ Yes         |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ❌ Yes         |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 120ns @ 4GHz |
| Cold read cost                        | ~ 695ns @ 4GHz |
| Step granularity                      | 125ns          |

</details>

<details>
  <summary><code>virtual</code> (<code>CLOCK_VIRTUAL</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this process, user mode only

| Property                               | Value                                   |
| -------------------------------------- | --------------------------------------- |
| Reacts to OS time changes              | ✅ No                                   |
| Reacts to NTP changes                  | ✅ No                                   |
| Counts system suspension times         | ✅ No                                   |
| Advances while process is de-scheduled | ✅ No                                   |
| Might appear to go backwards           | ✅ No                                   |
| Reads a cached value                   | ❌ Yes, for all threads                 |
| Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
| Warm read cost                         | ~ 145ns + up to ~ 10ns/thread @ 4GHz    |
| Cold read cost                         | ~ 495ns @ 4GHz                          |
| Step granularity                       | 1µs                                     |

</details>

<details>
  <summary><code>prof</code> (<code>CLOCK_PROF</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this process

| Property                               | Value                                   |
| -------------------------------------- | --------------------------------------- |
| Reacts to OS time changes              | ✅ No                                   |
| Reacts to NTP changes                  | ✅ No                                   |
| Counts system suspension times         | ✅ No                                   |
| Advances while process is de-scheduled | ✅ No                                   |
| Might appear to go backwards           | ✅ No                                   |
| Reads a cached value                   | ❌ Yes, for all threads                 |
| Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
| Warm read cost                         | ~ 145ns + up to ~ 10ns/thread @ 4GHz    |
| Cold read cost                         | ~ 560ns @ 4GHz                          |
| Step granularity                       | 1µs                                     |

</details>

<details>
  <summary><code>second</code> (<code>CLOCK_SECOND</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures Wall time, whole seconds only

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ❌ Yes         |
| Reacts to NTP changes                 | ❌ Yes         |
| Counts system suspension times        | ❌ Yes         |
| Advances while thread is de-scheduled | ❌ Yes         |
| Might appear to go backwards          | ❌ Yes         |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ❌ ~ 1s        |
| Warm read cost                        | ~ 18ns @ 4GHz  |
| Cold read cost                        | ~ 265ns @ 4GHz |
| Step granularity                      | 1s             |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this process

| Property                               | Value                                     |
| -------------------------------------- | ----------------------------------------- |
| Reacts to OS time changes              | ✅ No                                     |
| Reacts to NTP changes                  | ✅ No                                     |
| Counts system suspension times         | ✅ No                                     |
| Advances while process is de-scheduled | ✅ No                                     |
| Might appear to go backwards           | ✅ No                                     |
| Reads a cached value                   | ❌ Yes, for other threads                 |
| Max staleness                          | ❌ ~ 8ms @ stathz 127, from other threads |
| Warm read cost                         | ~ 145ns + ~ 11ns/thread @ 4GHz            |
| Cold read cost                         | ~ 595ns @ 4GHz                            |
| Step granularity                       | 170ns                                     |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)

Measures CPU time used by this thread

| Property                              | Value          |
| ------------------------------------- | -------------- |
| Reacts to OS time changes             | ✅ No          |
| Reacts to NTP changes                 | ✅ No          |
| Counts system suspension times        | ✅ No          |
| Advances while thread is de-scheduled | ✅ No          |
| Might appear to go backwards          | ✅ No          |
| Reads a cached value                  | ✅ No          |
| Max staleness                         | ✅ None        |
| Warm read cost                        | ~ 120ns @ 4GHz |
| Cold read cost                        | ~ 495ns @ 4GHz |
| Step granularity                      | 125ns          |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this process spent running its own code

| Property                               | Value                                   |
| -------------------------------------- | --------------------------------------- |
| Reacts to OS time changes              | ✅ No                                   |
| Reacts to NTP changes                  | ✅ No                                   |
| Counts system suspension times         | ✅ No                                   |
| Advances while process is de-scheduled | ✅ No                                   |
| Might appear to go backwards           | ✅ No                                   |
| Reads a cached value                   | ❌ Yes, for all threads                 |
| Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
| Warm read cost                         | ~ 150ns + ~ 16ns/thread @ 4GHz          |
| Cold read cost                         | ~ 490ns @ 4GHz                          |
| Step granularity                       | 1µs                                     |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this process's behalf

| Property                               | Value                                   |
| -------------------------------------- | --------------------------------------- |
| Reacts to OS time changes              | ✅ No                                   |
| Reacts to NTP changes                  | ✅ No                                   |
| Counts system suspension times         | ✅ No                                   |
| Advances while process is de-scheduled | ✅ No                                   |
| Might appear to go backwards           | ✅ No                                   |
| Reads a cached value                   | ❌ Yes, for all threads                 |
| Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
| Warm read cost                         | ~ 150ns + ~ 16ns/thread @ 4GHz          |
| Cold read cost                         | ~ 490ns @ 4GHz                          |
| Step granularity                       | 1µs                                     |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this thread spent running its own code

| Property                              | Value                 |
| ------------------------------------- | --------------------- |
| Reacts to OS time changes             | ✅ No                 |
| Reacts to NTP changes                 | ✅ No                 |
| Counts system suspension times        | ✅ No                 |
| Advances while thread is de-scheduled | ✅ No                 |
| Might appear to go backwards          | ✅ No                 |
| Reads a cached value                  | ❌ Yes                |
| Max staleness                         | ❌ ~ 8ms @ stathz 127 |
| Warm read cost                        | ~ 145ns @ 4GHz        |
| Cold read cost                        | ~ 425ns @ 4GHz        |
| Step granularity                      | 1µs                   |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this thread's behalf

| Property                              | Value                 |
| ------------------------------------- | --------------------- |
| Reacts to OS time changes             | ✅ No                 |
| Reacts to NTP changes                 | ✅ No                 |
| Counts system suspension times        | ✅ No                 |
| Advances while thread is de-scheduled | ✅ No                 |
| Might appear to go backwards          | ✅ No                 |
| Reads a cached value                  | ❌ Yes                |
| Max staleness                         | ❌ ~ 8ms @ stathz 127 |
| Warm read cost                        | ~ 145ns @ 4GHz        |
| Cold read cost                        | ~ 425ns @ 4GHz        |
| Step granularity                      | 1µs                   |

</details>

</details>

<details>
  <summary><b>OpenBSD</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Wall time, counted from 1970-01-01 UTC

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ❌ Yes          |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ❌ Yes          |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ❌ Yes          |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 21ns @ 4GHz   |
| Cold read cost                        | ~ 19.7µs @ 4GHz |
| Step granularity                      | 42ns            |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Elapsed time, from an arbitrary point

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ✅ No           |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ❌ Yes          |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ✅ No           |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 20ns @ 4GHz   |
| Cold read cost                        | ~ 21.9µs @ 4GHz |
| Step granularity                      | 42ns            |

</details>

<details>
  <summary><code>boottime</code> (<code>CLOCK_BOOTTIME</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Elapsed time, since the machine booted

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ✅ No           |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ❌ Yes          |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ✅ No           |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 20ns @ 4GHz   |
| Cold read cost                        | ~ 18.2µs @ 4GHz |
| Step granularity                      | 42ns            |

</details>

<details>
  <summary><code>uptime</code> (<code>CLOCK_UPTIME</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures Elapsed time, since the machine booted

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ✅ No           |
| Reacts to NTP changes                 | ❌ Yes          |
| Counts system suspension times        | ✅ No           |
| Advances while thread is de-scheduled | ❌ Yes          |
| Might appear to go backwards          | ✅ No           |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 20ns @ 4GHz   |
| Cold read cost                        | ~ 15.9µs @ 4GHz |
| Step granularity                      | 42ns            |

</details>

<details>
  <summary><code>processCPUTime</code> (<code>CLOCK_PROCESS_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures CPU time used by this process

| Property                               | Value                          |
| -------------------------------------- | ------------------------------ |
| Reacts to OS time changes              | ✅ No                          |
| Reacts to NTP changes                  | ✅ No                          |
| Counts system suspension times         | ✅ No                          |
| Advances while process is de-scheduled | ✅ No                          |
| Might appear to go backwards           | ✅ No                          |
| Reads a cached value                   | ❌ Yes, for other threads      |
| Max staleness                          | ❌ ~ 200ms, from other threads |
| Warm read cost                         | ~ 235ns + ~ 5ns/thread @ 4GHz  |
| Cold read cost                         | ~ 15.4µs @ 4GHz                |
| Step granularity                       | 291ns                          |

</details>

<details>
  <summary><code>threadCPUTime</code> (<code>CLOCK_THREAD_CPUTIME_ID</code>)</summary>

[clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)

Measures CPU time used by this thread

| Property                              | Value           |
| ------------------------------------- | --------------- |
| Reacts to OS time changes             | ✅ No           |
| Reacts to NTP changes                 | ✅ No           |
| Counts system suspension times        | ✅ No           |
| Advances while thread is de-scheduled | ✅ No           |
| Might appear to go backwards          | ✅ No           |
| Reads a cached value                  | ✅ No           |
| Max staleness                         | ✅ None         |
| Warm read cost                        | ~ 195ns @ 4GHz  |
| Cold read cost                        | ~ 15.5µs @ 4GHz |
| Step granularity                      | 125ns           |

</details>

<details>
  <summary><code>processUserTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this process spent running its own code

| Property                               | Value                                    |
| -------------------------------------- | ---------------------------------------- |
| Reacts to OS time changes              | ✅ No                                    |
| Reacts to NTP changes                  | ✅ No                                    |
| Counts system suspension times         | ✅ No                                    |
| Advances while process is de-scheduled | ✅ No                                    |
| Might appear to go backwards           | ✅ No                                    |
| Reads a cached value                   | ❌ Yes, for all threads                  |
| Max staleness                          | ❌ ~ 10ms @ stathz 100, from all threads |
| Warm read cost                         | ~ 190ns + ~ 11ns/thread @ 4GHz           |
| Cold read cost                         | ~ 5µs @ 4GHz                             |
| Step granularity                       | 10ms @ stathz 100                        |

</details>

<details>
  <summary><code>processSystemTime</code> (<code>RUSAGE_SELF</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this process's behalf

| Property                               | Value                                    |
| -------------------------------------- | ---------------------------------------- |
| Reacts to OS time changes              | ✅ No                                    |
| Reacts to NTP changes                  | ✅ No                                    |
| Counts system suspension times         | ✅ No                                    |
| Advances while process is de-scheduled | ✅ No                                    |
| Might appear to go backwards           | ✅ No                                    |
| Reads a cached value                   | ❌ Yes, for all threads                  |
| Max staleness                          | ❌ ~ 10ms @ stathz 100, from all threads |
| Warm read cost                         | ~ 190ns + ~ 11ns/thread @ 4GHz           |
| Cold read cost                         | ~ 5µs @ 4GHz                             |
| Step granularity                       | 10ms @ stathz 100                        |

</details>

<details>
  <summary><code>threadUserTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time this thread spent running its own code

| Property                              | Value                  |
| ------------------------------------- | ---------------------- |
| Reacts to OS time changes             | ✅ No                  |
| Reacts to NTP changes                 | ✅ No                  |
| Counts system suspension times        | ✅ No                  |
| Advances while thread is de-scheduled | ✅ No                  |
| Might appear to go backwards          | ✅ No                  |
| Reads a cached value                  | ❌ Yes                 |
| Max staleness                         | ❌ ~ 10ms @ stathz 100 |
| Warm read cost                        | ~ 215ns @ 4GHz         |
| Cold read cost                        | ~ 4.5µs @ 4GHz         |
| Step granularity                      | 10ms @ stathz 100      |

</details>

<details>
  <summary><code>threadSystemTime</code> (<code>RUSAGE_THREAD</code>)</summary>

[getrusage(2)](https://man.openbsd.org/getrusage.2)

This is this library's own clock identifier and not one of the clock ids the platform declares.

Measures CPU time the kernel spent on this thread's behalf

| Property                              | Value                  |
| ------------------------------------- | ---------------------- |
| Reacts to OS time changes             | ✅ No                  |
| Reacts to NTP changes                 | ✅ No                  |
| Counts system suspension times        | ✅ No                  |
| Advances while thread is de-scheduled | ✅ No                  |
| Might appear to go backwards          | ✅ No                  |
| Reads a cached value                  | ❌ Yes                 |
| Max staleness                         | ❌ ~ 10ms @ stathz 100 |
| Warm read cost                        | ~ 215ns @ 4GHz         |
| Cold read cost                        | ~ 4.5µs @ 4GHz         |
| Step granularity                      | 10ms @ stathz 100      |

</details>

</details>

<details>
  <summary><b>WASI</b></summary>

<details>
  <summary><code>realtime</code> (<code>CLOCK_REALTIME</code>)</summary>

[WASI preview1](https://github.com/WebAssembly/WASI/blob/snapshot-01/phases/snapshot/docs.md)

Measures Wall time, counted from 1970-01-01 UTC

Whether it actually counts from 1970 (not e.g. boot time) is runtime-dependent.

| Property                              | Value                                 |
| ------------------------------------- | ------------------------------------- |
| Reacts to OS time changes             | Runtime-dependent                     |
| Reacts to NTP changes                 | Runtime-dependent                     |
| Counts system suspension times        | Runtime-dependent                     |
| Advances while thread is de-scheduled | ❌ Yes                                |
| Might appear to go backwards          | Runtime-dependent                     |
| Reads a cached value                  | Runtime-dependent                     |
| Max staleness                         | ✅ None                               |
| Warm read cost                        | ~ 29-282ns; ~ 57ns on wasmtime @ 4GHz |
| Cold read cost                        | N/A                                   |
| Step granularity                      | 1µs on wasmtime                       |

</details>

<details>
  <summary><code>monotonic</code> (<code>CLOCK_MONOTONIC</code>)</summary>

[WASI preview1](https://github.com/WebAssembly/WASI/blob/snapshot-01/phases/snapshot/docs.md)

Measures Elapsed time, from an arbitrary point

| Property                              | Value                                 |
| ------------------------------------- | ------------------------------------- |
| Reacts to OS time changes             | ✅ No                                 |
| Reacts to NTP changes                 | Runtime-dependent                     |
| Counts system suspension times        | Runtime-dependent                     |
| Advances while thread is de-scheduled | ❌ Yes                                |
| Might appear to go backwards          | ✅ No                                 |
| Reads a cached value                  | Runtime-dependent                     |
| Max staleness                         | ✅ None                               |
| Warm read cost                        | ~ 25-284ns; ~ 56ns on wasmtime @ 4GHz |
| Cold read cost                        | N/A                                   |
| Step granularity                      | 42ns on wasmtime                      |

</details>

</details>

<details>
  <summary><b>Fallback</b></summary>

<details>
  <summary><code>monotonic</code> (<code>std::chrono::steady_clock</code>)</summary>

[cppreference](https://en.cppreference.com/w/cpp/chrono/steady_clock)

Measures Elapsed time, from an arbitrary point

| Property                              | Value                    |
| ------------------------------------- | ------------------------ |
| Reacts to OS time changes             | ✅ No                    |
| Reacts to NTP changes                 | ✅ No                    |
| Counts system suspension times        | Implementation-dependant |
| Advances while thread is de-scheduled | ❌ Yes                   |
| Might appear to go backwards          | ✅ No                    |
| Reads a cached value                  | Implementation-dependant |
| Max staleness                         | Implementation-dependant |
| Warm read cost                        | Implementation-dependant |
| Cold read cost                        | Implementation-dependant |
| Step granularity                      | Implementation-dependant |

</details>

<details>
  <summary><code>realtime</code> (<code>std::chrono::system_clock</code>)</summary>

[cppreference](https://en.cppreference.com/w/cpp/chrono/system_clock)

Measures Wall time, counted from 1970-01-01 UTC (guaranteed since C++20)

| Property                              | Value                    |
| ------------------------------------- | ------------------------ |
| Reacts to OS time changes             | ❌ Yes                   |
| Reacts to NTP changes                 | ❌ Yes                   |
| Counts system suspension times        | ❌ Yes                   |
| Advances while thread is de-scheduled | ❌ Yes                   |
| Might appear to go backwards          | ❌ Yes                   |
| Reads a cached value                  | Implementation-dependant |
| Max staleness                         | Implementation-dependant |
| Warm read cost                        | Implementation-dependant |
| Cold read cost                        | Implementation-dependant |
| Step granularity                      | Implementation-dependant |

</details>

<details>
  <summary><code>highResolution</code> (<code>std::chrono::high_resolution_clock</code>)</summary>

[cppreference](https://en.cppreference.com/w/cpp/chrono/high_resolution_clock)

Measurements dependant on the underlying implementation: `monotonic` on libc++ and Microsoft's STL, `realtime` on libstdc++

| Property                              | Value                    |
| ------------------------------------- | ------------------------ |
| Reacts to OS time changes             | Implementation-dependant |
| Reacts to NTP changes                 | Implementation-dependant |
| Counts system suspension times        | Implementation-dependant |
| Advances while thread is de-scheduled | ❌ Yes                   |
| Might appear to go backwards          | Implementation-dependant |
| Reads a cached value                  | Implementation-dependant |
| Max staleness                         | Implementation-dependant |
| Warm read cost                        | Implementation-dependant |
| Cold read cost                        | Implementation-dependant |
| Step granularity                      | Implementation-dependant |

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
| `continuous.now` | 10.6 ns               | 24.7 ns                  | 2.34x   |
| `suspending.now` | 10.8 ns               | 23.1 ns                  | 2.14x   |

| Benchmark              | `SystemClock` instructions | Standard Library instructions |
| ---------------------- | -------------------------- | ----------------------------- |
| `realtime.now`         | 146                        | N/A                           |
| `realtimeCoarse.now`   | 146                        | N/A                           |
| `continuous.now`       | 94                         | 205                           |
| `continuousCoarse.now` | 104                        | N/A                           |
| `suspending.now`       | 101                        | 210                           |
| `suspendingCoarse.now` | 91                         | N/A                           |

### Against glibc

These were performed on a dedicated-cpu-core AMD EPYC-Milan VM from Hetzner, on Ubuntu 24.04.

| Benchmark        | `SystemClock` (ns/op) | Standard Library (ns/op) | Speedup |
| ---------------- | --------------------- | ------------------------ | ------- |
| `continuous.now` | 27.5 ns               | 29.8 ns                  | 1.08x   |
| `suspending.now` | 27.5 ns               | 29.5 ns                  | 1.07x   |

| Benchmark              | `SystemClock` instructions | Standard Library instructions |
| ---------------------- | -------------------------- | ----------------------------- |
| `realtime.now`         | 132                        | N/A                           |
| `realtimeCoarse.now`   | 86                         | N/A                           |
| `continuous.now`       | 132                        | 200                           |
| `continuousCoarse.now` | 132                        | N/A                           |
| `suspending.now`       | 132                        | 198                           |
| `suspendingCoarse.now` | 86                         | N/A                           |

#### Additional Notes

* To see up to date information about performance of this package, please go to this [benchmarks list](https://github.com/swift-dns/swift-system-clock/actions/workflows/benchmarks.yml?query=branch%3Amain), and choose the most recent benchmark. You'll see a summary of the benchmark there.
* The results above are all reproducible by simply running `scripts/benchmark.sh` on a machine of your own.
