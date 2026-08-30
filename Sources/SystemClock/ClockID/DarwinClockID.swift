public import CSystemClock

/// A Darwin clock identifier that can be passed to `clock_gettime(3)`.
public struct DarwinClockID: Sendable, Hashable, RawRepresentable {
    public let rawValue: Int32

    @inlinable
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

extension DarwinClockID {
    /// `CLOCK_REALTIME`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
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
    /// | Typical read cost                 | ~ 12ns @ 4GHz  |
    /// | Cold read cost                    | ~ 200ns @ 4GHz |
    /// | Step granularity                  | 1µs            |
    @inlinable
    public static var realtime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_realtime)
    }

    /// `CLOCK_MONOTONIC`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
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
    /// | Typical read cost                 | ~ 17ns @ 4GHz  |
    /// | Cold read cost                    | ~ 165ns @ 4GHz |
    /// | Step granularity                  | 1µs            |
    @inlinable
    public static var monotonic: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_monotonic)
    }

    /// `CLOCK_MONOTONIC_RAW`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ❌ Yes         |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ✅ No          |
    /// | Possible staleness                | ✅ None        |
    /// | Typical read cost                 | ~ 13ns @ 4GHz  |
    /// | Cold read cost                    | ~ 135ns @ 4GHz |
    /// | Step granularity                  | 42ns           |
    @inlinable
    public static var monotonicRaw: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_monotonic_raw)
    }

    /// `CLOCK_MONOTONIC_RAW_APPROX`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ❌ Yes         |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 1ms       |
    /// | Typical read cost                 | ~ 5.5ns @ 4GHz |
    /// | Cold read cost                    | ~ 230ns @ 4GHz |
    /// | Step granularity                  | 42ns           |
    @inlinable
    public static var monotonicRawApproximate: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_monotonic_raw_approx)
    }

    /// `CLOCK_UPTIME_RAW`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ✅ No          |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ✅ No          |
    /// | Possible staleness                | ✅ None        |
    /// | Typical read cost                 | ~ 13ns @ 4GHz  |
    /// | Cold read cost                    | ~ 165ns @ 4GHz |
    /// | Step granularity                  | 42ns           |
    @inlinable
    public static var uptimeRaw: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_uptime_raw)
    }

    /// `CLOCK_UPTIME_RAW_APPROX`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ✅ No          |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 1ms       |
    /// | Typical read cost                 | ~ 5ns @ 4GHz   |
    /// | Cold read cost                    | ~ 165ns @ 4GHz |
    /// | Step granularity                  | 42ns           |
    @inlinable
    public static var uptimeRawApproximate: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_uptime_raw_approx)
    }

    /// `CLOCK_PROCESS_CPUTIME_ID`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: CPU time used by this process
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
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
    /// | Typical read cost                 | ~ 210ns @ 4GHz |
    /// | Cold read cost                    | ~ 1.3µs @ 4GHz |
    /// | Step granularity                  | 1µs            |
    @inlinable
    public static var processCPUTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_process_cpu_time)
    }

    /// `CLOCK_THREAD_CPUTIME_ID`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures: CPU time used by this thread
    ///
    /// The following values are usually accurate, but can occasionally contain inaccuracies.
    /// For better accuracy, measure with your specific kernel and hardware.
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
    /// | Typical read cost                 | ~ 115ns @ 4GHz |
    /// | Cold read cost                    | ~ 460ns @ 4GHz |
    /// | Step granularity                  | 125ns          |
    @inlinable
    public static var threadCPUTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_thread_cpu_time)
    }
}
