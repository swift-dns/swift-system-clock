public import CSystemClock

/// A Darwin clock identifier.
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
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ❌ Yes         |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ❌ Yes         |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ❌ Yes         |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 12ns @ 4GHz  |
    /// | Cold read cost                        | ~ 200ns @ 4GHz |
    /// | Step granularity                      | 1µs            |
    @inlinable
    public static var realtime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_realtime)
    }

    /// `CLOCK_MONOTONIC`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ❌ Yes         |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 17ns @ 4GHz  |
    /// | Cold read cost                        | ~ 165ns @ 4GHz |
    /// | Step granularity                      | 1µs            |
    @inlinable
    public static var monotonic: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_monotonic)
    }

    /// `CLOCK_MONOTONIC_RAW`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ✅ No          |
    /// | Counts system suspension times        | ❌ Yes         |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 13ns @ 4GHz  |
    /// | Cold read cost                        | ~ 135ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var monotonicRaw: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_monotonic_raw)
    }

    /// `CLOCK_MONOTONIC_RAW_APPROX`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ✅ No          |
    /// | Counts system suspension times        | ❌ Yes         |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ❌ Yes         |
    /// | Max staleness                         | ❌ ~ 0.5-2ms   |
    /// | Warm read cost                        | ~ 5.5ns @ 4GHz |
    /// | Cold read cost                        | ~ 230ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var monotonicRawApproximate: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_monotonic_raw_approx)
    }

    /// `CLOCK_UPTIME_RAW`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ✅ No          |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 13ns @ 4GHz  |
    /// | Cold read cost                        | ~ 165ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var uptimeRaw: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_uptime_raw)
    }

    /// `CLOCK_UPTIME_RAW_APPROX`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ✅ No          |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ❌ Yes         |
    /// | Max staleness                         | ❌ ~ 0.5-2ms   |
    /// | Warm read cost                        | ~ 5ns @ 4GHz   |
    /// | Cold read cost                        | ~ 165ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var uptimeRawApproximate: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_uptime_raw_approx)
    }

    /// `CLOCK_PROCESS_CPUTIME_ID`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures CPU time used by this process
    ///
    /// | Property                               | Value                               |
    /// | -------------------------------------- | ----------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                               |
    /// | Reacts to NTP changes                  | ✅ No                               |
    /// | Counts system suspension times         | ✅ No                               |
    /// | Advances while process is de-scheduled | ✅ No                               |
    /// | Might appear to go backwards           | ✅ No                               |
    /// | Reads a cached value                   | ❌ Yes, for other threads           |
    /// | Max staleness                          | ❌ ~ 10ms, from other threads       |
    /// | Warm read cost                         | ~ 210ns + up to ~ 8ns/thread @ 4GHz |
    /// | Cold read cost                         | ~ 1.3µs @ 4GHz                      |
    /// | Step granularity                       | 1µs                                 |
    @inlinable
    public static var processCPUTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_process_cpu_time)
    }

    /// `CLOCK_THREAD_CPUTIME_ID`
    ///
    /// [clock_gettime(3)](https://github.com/apple-oss-distributions/Libc/blob/main/gen/clock_gettime.3)
    ///
    /// Measures CPU time used by this thread
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ✅ No          |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ✅ No          |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 115ns @ 4GHz |
    /// | Cold read cost                        | ~ 460ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var threadCPUTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_darwin_thread_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://keith.github.io/xcode-man-pages/getrusage.2.html)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time this process spent running its own code
    ///
    /// | Property                               | Value                               |
    /// | -------------------------------------- | ----------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                               |
    /// | Reacts to NTP changes                  | ✅ No                               |
    /// | Counts system suspension times         | ✅ No                               |
    /// | Advances while process is de-scheduled | ✅ No                               |
    /// | Might appear to go backwards           | ✅ No                               |
    /// | Reads a cached value                   | ❌ Yes, for other threads           |
    /// | Max staleness                          | ❌ ~ 10ms, from other threads       |
    /// | Warm read cost                         | ~ 210ns + up to ~ 8ns/thread @ 4GHz |
    /// | Cold read cost                         | ~ 4.3µs @ 4GHz                      |
    /// | Step granularity                       | 1µs                                 |
    @inlinable
    public static var processUserTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_process_user_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://keith.github.io/xcode-man-pages/getrusage.2.html)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time the kernel spent on this process's behalf
    ///
    /// | Property                               | Value                               |
    /// | -------------------------------------- | ----------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                               |
    /// | Reacts to NTP changes                  | ✅ No                               |
    /// | Counts system suspension times         | ✅ No                               |
    /// | Advances while process is de-scheduled | ✅ No                               |
    /// | Might appear to go backwards           | ✅ No                               |
    /// | Reads a cached value                   | ❌ Yes, for other threads           |
    /// | Max staleness                          | ❌ ~ 10ms, from other threads       |
    /// | Warm read cost                         | ~ 210ns + up to ~ 8ns/thread @ 4GHz |
    /// | Cold read cost                         | ~ 4.5µs @ 4GHz                      |
    /// | Step granularity                       | 1µs                                 |
    @inlinable
    public static var processSystemTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_process_system_cpu_time)
    }

    /// `thread_info`, `THREAD_BASIC_INFO`
    ///
    /// [thread_info](https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/mach/thread_act.defs)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time this thread spent running its own code
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ✅ No          |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ✅ No          |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 460ns @ 4GHz |
    /// | Cold read cost                        | ~ 5.8µs @ 4GHz |
    /// | Step granularity                      | 1µs            |
    @inlinable
    public static var threadUserTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_thread_user_cpu_time)
    }

    /// `thread_info`, `THREAD_BASIC_INFO`
    ///
    /// [thread_info](https://github.com/apple-oss-distributions/xnu/blob/main/osfmk/mach/thread_act.defs)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time the kernel spent on this thread's behalf
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ✅ No          |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ✅ No          |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 460ns @ 4GHz |
    /// | Cold read cost                        | ~ 5.2µs @ 4GHz |
    /// | Step granularity                      | 1µs            |
    @inlinable
    public static var threadSystemTime: DarwinClockID {
        DarwinClockID(rawValue: csystem_clock_thread_system_cpu_time)
    }
}
