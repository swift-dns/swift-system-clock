public import CSystemClock

/// An OpenBSD clock identifier that can be passed to `clock_gettime(2)`.
public struct OpenBSDClockID: Sendable, Hashable, RawRepresentable {
    public let rawValue: Int32

    @inlinable
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

extension OpenBSDClockID {
    /// `CLOCK_REALTIME`
    ///
    /// [clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ❌ Yes          |
    /// | Affected by NTP changes           | N/A             |
    /// | Affected by system suspension     | ❌ Yes          |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ❌ Yes          |
    /// | Reads a cached value              | N/A             |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 21ns @ 4GHz   |
    /// | Cold read cost                    | ~ 19.7µs @ 4GHz |
    /// | Step granularity                  | 42ns            |
    @inlinable
    public static var realtime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_openbsd_realtime)
    }

    /// `CLOCK_MONOTONIC`
    ///
    /// [clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | N/A             |
    /// | Affected by system suspension     | N/A             |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | N/A             |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 20ns @ 4GHz   |
    /// | Cold read cost                    | ~ 21.9µs @ 4GHz |
    /// | Step granularity                  | 42ns            |
    @inlinable
    public static var monotonic: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_openbsd_monotonic)
    }

    /// `CLOCK_BOOTTIME`
    ///
    /// [clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)
    ///
    /// Measures Elapsed time, since the machine booted
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | N/A             |
    /// | Affected by system suspension     | ❌ Yes          |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | N/A             |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 20ns @ 4GHz   |
    /// | Cold read cost                    | ~ 18.2µs @ 4GHz |
    /// | Step granularity                  | 42ns            |
    @inlinable
    public static var boottime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_openbsd_boottime)
    }

    /// `CLOCK_UPTIME`
    ///
    /// [clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)
    ///
    /// Measures Elapsed time, since the machine booted
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | N/A             |
    /// | Affected by system suspension     | ✅ No           |
    /// | Affected by process de-scheduling | ❌ Yes          |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | N/A             |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 20ns @ 4GHz   |
    /// | Cold read cost                    | ~ 15.9µs @ 4GHz |
    /// | Step granularity                  | 42ns            |
    @inlinable
    public static var uptime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_openbsd_uptime)
    }

    /// `CLOCK_PROCESS_CPUTIME_ID`
    ///
    /// [clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)
    ///
    /// Measures CPU time used by this process
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | ✅ No           |
    /// | Affected by system suspension     | ✅ No           |
    /// | Affected by process de-scheduling | ✅ No           |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | N/A             |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 235ns @ 4GHz  |
    /// | Cold read cost                    | ~ 15.4µs @ 4GHz |
    /// | Step granularity                  | 291ns           |
    @inlinable
    public static var processCPUTime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_openbsd_process_cpu_time)
    }

    /// `CLOCK_THREAD_CPUTIME_ID`
    ///
    /// [clock_gettime(2)](https://man.openbsd.org/clock_gettime.2)
    ///
    /// Measures CPU time used by this thread
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value           |
    /// | --------------------------------- | --------------- |
    /// | Affected by OS clock changes      | ✅ No           |
    /// | Affected by NTP changes           | ✅ No           |
    /// | Affected by system suspension     | ✅ No           |
    /// | Affected by process de-scheduling | ✅ No           |
    /// | Appears to go backwards           | ✅ No           |
    /// | Reads a cached value              | N/A             |
    /// | Possible staleness                | ✅ None         |
    /// | Typical read cost                 | ~ 195ns @ 4GHz  |
    /// | Cold read cost                    | ~ 15.5µs @ 4GHz |
    /// | Step granularity                  | 125ns           |
    @inlinable
    public static var threadCPUTime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_openbsd_thread_cpu_time)
    }
}
