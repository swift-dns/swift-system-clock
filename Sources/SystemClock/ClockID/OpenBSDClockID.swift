public import CSystemClock

/// An OpenBSD clock identifier.
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
    /// | Property                              | Value           |
    /// | ------------------------------------- | --------------- |
    /// | Reacts to OS time changes             | ❌ Yes          |
    /// | Reacts to NTP changes                 | ❌ Yes          |
    /// | Counts system suspension times        | ❌ Yes          |
    /// | Advances while thread is de-scheduled | ❌ Yes          |
    /// | Might appear to go backwards          | ❌ Yes          |
    /// | Reads a cached value                  | ✅ No           |
    /// | Max staleness                         | ✅ None         |
    /// | Warm read cost                        | ~ 21ns @ 4GHz   |
    /// | Cold read cost                        | ~ 19.7µs @ 4GHz |
    /// | Step granularity                      | 42ns            |
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
    /// | Property                              | Value           |
    /// | ------------------------------------- | --------------- |
    /// | Reacts to OS time changes             | ✅ No           |
    /// | Reacts to NTP changes                 | ❌ Yes          |
    /// | Counts system suspension times        | ❌ Yes          |
    /// | Advances while thread is de-scheduled | ❌ Yes          |
    /// | Might appear to go backwards          | ✅ No           |
    /// | Reads a cached value                  | ✅ No           |
    /// | Max staleness                         | ✅ None         |
    /// | Warm read cost                        | ~ 20ns @ 4GHz   |
    /// | Cold read cost                        | ~ 21.9µs @ 4GHz |
    /// | Step granularity                      | 42ns            |
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
    /// | Property                              | Value           |
    /// | ------------------------------------- | --------------- |
    /// | Reacts to OS time changes             | ✅ No           |
    /// | Reacts to NTP changes                 | ❌ Yes          |
    /// | Counts system suspension times        | ❌ Yes          |
    /// | Advances while thread is de-scheduled | ❌ Yes          |
    /// | Might appear to go backwards          | ✅ No           |
    /// | Reads a cached value                  | ✅ No           |
    /// | Max staleness                         | ✅ None         |
    /// | Warm read cost                        | ~ 20ns @ 4GHz   |
    /// | Cold read cost                        | ~ 18.2µs @ 4GHz |
    /// | Step granularity                      | 42ns            |
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
    /// | Property                              | Value           |
    /// | ------------------------------------- | --------------- |
    /// | Reacts to OS time changes             | ✅ No           |
    /// | Reacts to NTP changes                 | ❌ Yes          |
    /// | Counts system suspension times        | ✅ No           |
    /// | Advances while thread is de-scheduled | ❌ Yes          |
    /// | Might appear to go backwards          | ✅ No           |
    /// | Reads a cached value                  | ✅ No           |
    /// | Max staleness                         | ✅ None         |
    /// | Warm read cost                        | ~ 20ns @ 4GHz   |
    /// | Cold read cost                        | ~ 15.9µs @ 4GHz |
    /// | Step granularity                      | 42ns            |
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
    /// | Property                              | Value                         |
    /// | ------------------------------------- | ----------------------------- |
    /// | Reacts to OS time changes             | ✅ No                         |
    /// | Reacts to NTP changes                 | ✅ No                         |
    /// | Counts system suspension times        | ✅ No                         |
    /// | Advances while thread is de-scheduled | ✅ No                         |
    /// | Might appear to go backwards          | ✅ No                         |
    /// | Reads a cached value                  | ✅ No                         |
    /// | Max staleness                         | ✅ None                       |
    /// | Warm read cost                        | ~ 235ns + ~ 5ns/thread @ 4GHz |
    /// | Cold read cost                        | ~ 15.4µs @ 4GHz               |
    /// | Step granularity                      | 291ns                         |
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
    /// | Property                              | Value           |
    /// | ------------------------------------- | --------------- |
    /// | Reacts to OS time changes             | ✅ No           |
    /// | Reacts to NTP changes                 | ✅ No           |
    /// | Counts system suspension times        | ✅ No           |
    /// | Advances while thread is de-scheduled | ✅ No           |
    /// | Might appear to go backwards          | ✅ No           |
    /// | Reads a cached value                  | ✅ No           |
    /// | Max staleness                         | ✅ None         |
    /// | Warm read cost                        | ~ 195ns @ 4GHz  |
    /// | Cold read cost                        | ~ 15.5µs @ 4GHz |
    /// | Step granularity                      | 125ns           |
    @inlinable
    public static var threadCPUTime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_openbsd_thread_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://man.openbsd.org/getrusage.2)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time this process spent running its own code
    ///
    /// | Property                              | Value                          |
    /// | ------------------------------------- | ------------------------------ |
    /// | Reacts to OS time changes             | ✅ No                          |
    /// | Reacts to NTP changes                 | ✅ No                          |
    /// | Counts system suspension times        | ✅ No                          |
    /// | Advances while thread is de-scheduled | ✅ No                          |
    /// | Might appear to go backwards          | ✅ No                          |
    /// | Reads a cached value                  | ❌ Yes                         |
    /// | Max staleness                         | ❌ ~ 10ms @ stathz 100         |
    /// | Warm read cost                        | ~ 190ns + ~ 11ns/thread @ 4GHz |
    /// | Cold read cost                        | ~ 5µs @ 4GHz                   |
    /// | Step granularity                      | 10ms @ stathz 100              |
    @inlinable
    public static var processUserTime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_process_user_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://man.openbsd.org/getrusage.2)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time the kernel spent on this process's behalf
    ///
    /// | Property                              | Value                          |
    /// | ------------------------------------- | ------------------------------ |
    /// | Reacts to OS time changes             | ✅ No                          |
    /// | Reacts to NTP changes                 | ✅ No                          |
    /// | Counts system suspension times        | ✅ No                          |
    /// | Advances while thread is de-scheduled | ✅ No                          |
    /// | Might appear to go backwards          | ✅ No                          |
    /// | Reads a cached value                  | ❌ Yes                         |
    /// | Max staleness                         | ❌ ~ 10ms @ stathz 100         |
    /// | Warm read cost                        | ~ 190ns + ~ 11ns/thread @ 4GHz |
    /// | Cold read cost                        | ~ 5µs @ 4GHz                   |
    /// | Step granularity                      | 10ms @ stathz 100              |
    @inlinable
    public static var processSystemTime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_process_system_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_THREAD`
    ///
    /// [getrusage(2)](https://man.openbsd.org/getrusage.2)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time this thread spent running its own code
    ///
    /// | Property                              | Value                  |
    /// | ------------------------------------- | ---------------------- |
    /// | Reacts to OS time changes             | ✅ No                  |
    /// | Reacts to NTP changes                 | ✅ No                  |
    /// | Counts system suspension times        | ✅ No                  |
    /// | Advances while thread is de-scheduled | ✅ No                  |
    /// | Might appear to go backwards          | ✅ No                  |
    /// | Reads a cached value                  | ❌ Yes                 |
    /// | Max staleness                         | ❌ ~ 10ms @ stathz 100 |
    /// | Warm read cost                        | ~ 215ns @ 4GHz         |
    /// | Cold read cost                        | ~ 4.5µs @ 4GHz         |
    /// | Step granularity                      | 10ms @ stathz 100      |
    @inlinable
    public static var threadUserTime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_thread_user_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_THREAD`
    ///
    /// [getrusage(2)](https://man.openbsd.org/getrusage.2)
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Measures CPU time the kernel spent on this thread's behalf
    ///
    /// | Property                              | Value                  |
    /// | ------------------------------------- | ---------------------- |
    /// | Reacts to OS time changes             | ✅ No                  |
    /// | Reacts to NTP changes                 | ✅ No                  |
    /// | Counts system suspension times        | ✅ No                  |
    /// | Advances while thread is de-scheduled | ✅ No                  |
    /// | Might appear to go backwards          | ✅ No                  |
    /// | Reads a cached value                  | ❌ Yes                 |
    /// | Max staleness                         | ❌ ~ 10ms @ stathz 100 |
    /// | Warm read cost                        | ~ 215ns @ 4GHz         |
    /// | Cold read cost                        | ~ 4.5µs @ 4GHz         |
    /// | Step granularity                      | 10ms @ stathz 100      |
    @inlinable
    public static var threadSystemTime: OpenBSDClockID {
        OpenBSDClockID(rawValue: csystem_clock_thread_system_cpu_time)
    }
}
