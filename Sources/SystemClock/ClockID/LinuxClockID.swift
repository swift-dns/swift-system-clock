public import CSystemClock

/// A Linux clock identifier that can be passed to `clock_gettime(2)`.
public struct LinuxClockID: Sendable, Hashable, RawRepresentable {
    public let rawValue: Int32

    @inlinable
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

extension LinuxClockID {
    /// `CLOCK_REALTIME`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ❌ Yes          |
    /// | Affected by NTP changes           | ❌ Yes          |
    /// | Affected by system suspension     | ❌ Yes          |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ❌ Yes          |
    /// | Reads a cached value              | ✅ No           |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 25ns @ 4GHz   |
    /// | Cold read cost                    | ~ 10.6µs @ 4GHz |
    /// | Step granularity                  | 20ns            |
    @inlinable
    public static var realtime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_realtime)
    }

    /// `CLOCK_REALTIME_ALARM`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ❌ Yes         |
    /// | Affected by NTP changes           | ❌ Yes         |
    /// | Affected by system suspension     | ❌ Yes         |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ❌ Yes         |
    /// | Reads a cached value              | ✅ No          |
    /// | Possible staleness                | ✅ None        |
    /// | Typical read cost                 | ~ 135ns @ 4GHz |
    /// | Cold read cost                    | ~ 4.6µs @ 4GHz |
    /// | Step granularity                  | 140ns          |
    @inlinable
    public static var realtimeAlarm: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_realtime_alarm)
    }

    /// `CLOCK_REALTIME_COARSE`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ❌ Yes         |
    /// | Affected by NTP changes           | ❌ Yes         |
    /// | Affected by system suspension     | ❌ Yes         |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ❌ Yes         |
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 2ms       |
    /// | Typical read cost                 | ~ 4.5ns @ 4GHz |
    /// | Cold read cost                    | ~ 9µs @ 4GHz   |
    /// | Step granularity                  | 1ms            |
    @inlinable
    public static var realtimeCoarse: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_realtime_coarse)
    }

    /// `CLOCK_TAI`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Wall time, on the TAI timescale
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ❌ Yes          |
    /// | Affected by NTP changes           | ❌ Yes          |
    /// | Affected by system suspension     | ❌ Yes          |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ❌ Yes          |
    /// | Reads a cached value              | ✅ No           |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 25ns @ 4GHz   |
    /// | Cold read cost                    | ~ 10.8µs @ 4GHz |
    /// | Step granularity                  | 20ns            |
    @inlinable
    public static var tai: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_tai)
    }

    /// `CLOCK_MONOTONIC`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | ❌ Yes          |
    /// | Affected by system suspension     | ✅ No           |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | ✅ No           |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 25ns @ 4GHz   |
    /// | Cold read cost                    | ~ 10.8µs @ 4GHz |
    /// | Step granularity                  | 20ns            |
    @inlinable
    public static var monotonic: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_monotonic)
    }

    /// `CLOCK_MONOTONIC_COARSE`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ❌ Yes         |
    /// | Affected by system suspension     | ✅ No          |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 2ms       |
    /// | Typical read cost                 | ~ 4.5ns @ 4GHz |
    /// | Cold read cost                    | ~ 9µs @ 4GHz   |
    /// | Step granularity                  | 1ms            |
    @inlinable
    public static var monotonicCoarse: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_monotonic_coarse)
    }

    /// `CLOCK_MONOTONIC_RAW`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | ✅ No           |
    /// | Affected by system suspension     | ✅ No           |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | ✅ No           |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 25ns @ 4GHz   |
    /// | Cold read cost                    | ~ 10.6µs @ 4GHz |
    /// | Step granularity                  | 20ns            |
    @inlinable
    public static var monotonicRaw: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_monotonic_raw)
    }

    /// `CLOCK_BOOTTIME`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | ❌ Yes          |
    /// | Affected by system suspension     | ❌ Yes          |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | ✅ No           |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 25ns @ 4GHz   |
    /// | Cold read cost                    | ~ 11.2µs @ 4GHz |
    /// | Step granularity                  | 20ns            |
    @inlinable
    public static var boottime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_boottime)
    }

    /// `CLOCK_BOOTTIME_ALARM`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ❌ Yes         |
    /// | Affected by system suspension     | ❌ Yes         |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ✅ No          |
    /// | Possible staleness                | ✅ None        |
    /// | Typical read cost                 | ~ 140ns @ 4GHz |
    /// | Cold read cost                    | ~ 4.9µs @ 4GHz |
    /// | Step granularity                  | 140ns          |
    @inlinable
    public static var boottimeAlarm: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_boottime_alarm)
    }

    /// `CLOCK_PROCESS_CPUTIME_ID`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures CPU time used by this process
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ✅ No          |
    /// | Affected by process de-scheduling | ✅ No          |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ✅ No          |
    /// | Possible staleness                | ✅ None        |
    /// | Typical read cost                 | ~ 165ns @ 4GHz |
    /// | Cold read cost                    | ~ 7µs @ 4GHz   |
    /// | Step granularity                  | 170ns          |
    @inlinable
    public static var processCPUTime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_process_cpu_time)
    }

    /// `CLOCK_THREAD_CPUTIME_ID`
    ///
    /// [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)
    ///
    /// Measures CPU time used by this thread
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ✅ No          |
    /// | Affected by process de-scheduling | ✅ No          |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ✅ No          |
    /// | Possible staleness                | ✅ None        |
    /// | Typical read cost                 | ~ 160ns @ 4GHz |
    /// | Cold read cost                    | ~ 6.5µs @ 4GHz |
    /// | Step granularity                  | 160ns          |
    @inlinable
    public static var threadCPUTime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_linux_thread_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time this process spent running its own code
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value            |
    /// | --------------------------------- | ---------------- |
    /// | Affected by OS clock changes      | ✅ No            |
    /// | Affected by NTP changes           | ✅ No            |
    /// | Affected by system suspension     | ✅ No            |
    /// | Affected by process de-scheduling | ✅ No            |
    /// | Appears to go backwards           | ✅ No            |
    /// | Reads a cached value              | ✅ No            |
    /// | Possible staleness                | ✅ None          |
    /// | Typical read cost                 | Not yet measured |
    /// | Cold read cost                    | Not yet measured |
    /// | Step granularity                  | 1µs              |
    @inlinable
    public static var processUserTime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_process_user_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time the kernel spent on this process's behalf
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value            |
    /// | --------------------------------- | ---------------- |
    /// | Affected by OS clock changes      | ✅ No            |
    /// | Affected by NTP changes           | ✅ No            |
    /// | Affected by system suspension     | ✅ No            |
    /// | Affected by process de-scheduling | ✅ No            |
    /// | Appears to go backwards           | ✅ No            |
    /// | Reads a cached value              | ✅ No            |
    /// | Possible staleness                | ✅ None          |
    /// | Typical read cost                 | Not yet measured |
    /// | Cold read cost                    | Not yet measured |
    /// | Step granularity                  | 1µs              |
    @inlinable
    public static var processSystemTime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_process_system_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_THREAD`
    ///
    /// [getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time this thread spent running its own code
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value            |
    /// | --------------------------------- | ---------------- |
    /// | Affected by OS clock changes      | ✅ No            |
    /// | Affected by NTP changes           | ✅ No            |
    /// | Affected by system suspension     | ✅ No            |
    /// | Affected by process de-scheduling | ✅ No            |
    /// | Appears to go backwards           | ✅ No            |
    /// | Reads a cached value              | ✅ No            |
    /// | Possible staleness                | ✅ None          |
    /// | Typical read cost                 | Not yet measured |
    /// | Cold read cost                    | Not yet measured |
    /// | Step granularity                  | 1µs              |
    @inlinable
    public static var threadUserTime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_thread_user_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_THREAD`
    ///
    /// [getrusage(2)](https://man7.org/linux/man-pages/man2/getrusage.2.html)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time the kernel spent on this thread's behalf
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value            |
    /// | --------------------------------- | ---------------- |
    /// | Affected by OS clock changes      | ✅ No            |
    /// | Affected by NTP changes           | ✅ No            |
    /// | Affected by system suspension     | ✅ No            |
    /// | Affected by process de-scheduling | ✅ No            |
    /// | Appears to go backwards           | ✅ No            |
    /// | Reads a cached value              | ✅ No            |
    /// | Possible staleness                | ✅ None          |
    /// | Typical read cost                 | Not yet measured |
    /// | Cold read cost                    | Not yet measured |
    /// | Step granularity                  | 1µs              |
    @inlinable
    public static var threadSystemTime: LinuxClockID {
        LinuxClockID(rawValue: csystem_clock_thread_system_cpu_time)
    }
}
