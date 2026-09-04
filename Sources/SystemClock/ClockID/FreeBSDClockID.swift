public import CSystemClock

/// A FreeBSD clock identifier.
public struct FreeBSDClockID: Sendable, Hashable, RawRepresentable {
    public let rawValue: Int32

    @inlinable
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

extension FreeBSDClockID {
    /// `CLOCK_REALTIME`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
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
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 300ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var realtime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_realtime)
    }

    /// `CLOCK_REALTIME_PRECISE`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
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
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 365ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var realtimePrecise: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_realtime_precise)
    }

    /// `CLOCK_REALTIME_FAST`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
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
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 265ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var realtimeFast: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_realtime_fast)
    }

    /// `CLOCK_MONOTONIC`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 265ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var monotonic: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_monotonic)
    }

    /// `CLOCK_MONOTONIC_PRECISE`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 265ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var monotonicPrecise: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_monotonic_precise)
    }

    /// `CLOCK_MONOTONIC_FAST`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                   |
    /// | ------------------------------------- | ----------------------- |
    /// | Reacts to OS time changes             | ✅ No                   |
    /// | Reacts to NTP changes                 | ❌ Yes                  |
    /// | Counts system suspension times        | ✅ No                   |
    /// | Advances while thread is de-scheduled | ❌ Yes                  |
    /// | Might appear to go backwards          | ✅ No                   |
    /// | Reads a cached value                  | ❌ Yes                  |
    /// | Max staleness                         | ❌ ~ 1ms @ kern.hz 1000 |
    /// | Warm read cost                        | ~ 3.5ns @ 4GHz          |
    /// | Cold read cost                        | ~ 235ns @ 4GHz          |
    /// | Step granularity                      | 1ms @ kern.hz 1000      |
    @inlinable
    public static var monotonicFast: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_monotonic_fast)
    }

    /// `CLOCK_UPTIME`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 265ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var uptime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_uptime)
    }

    /// `CLOCK_UPTIME_PRECISE`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 265ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var uptimePrecise: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_uptime_precise)
    }

    /// `CLOCK_UPTIME_FAST`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                   |
    /// | ------------------------------------- | ----------------------- |
    /// | Reacts to OS time changes             | ✅ No                   |
    /// | Reacts to NTP changes                 | ❌ Yes                  |
    /// | Counts system suspension times        | ✅ No                   |
    /// | Advances while thread is de-scheduled | ❌ Yes                  |
    /// | Might appear to go backwards          | ✅ No                   |
    /// | Reads a cached value                  | ❌ Yes                  |
    /// | Max staleness                         | ❌ ~ 1ms @ kern.hz 1000 |
    /// | Warm read cost                        | ~ 3.5ns @ 4GHz          |
    /// | Cold read cost                        | ~ 265ns @ 4GHz          |
    /// | Step granularity                      | 1ms @ kern.hz 1000      |
    @inlinable
    public static var uptimeFast: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_uptime_fast)
    }

    /// `CLOCK_BOOTTIME`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ✅ No          |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ✅ No          |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ✅ No          |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ✅ None        |
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 395ns @ 4GHz |
    /// | Step granularity                      | 42ns           |
    @inlinable
    public static var boottime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_boottime)
    }

    /// `CLOCK_TAI`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Wall time, on the TAI timescale
    ///
    /// Rejected with `EINVAL` until the machine's TAI offset has been set. Traps on runtime.
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
    /// | Warm read cost                        | ~ 120ns @ 4GHz |
    /// | Cold read cost                        | ~ 695ns @ 4GHz |
    /// | Step granularity                      | 125ns          |
    @inlinable
    public static var tai: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_tai)
    }

    /// `CLOCK_VIRTUAL`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures CPU time used by this process, user mode only
    ///
    /// | Property                               | Value                                   |
    /// | -------------------------------------- | --------------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                                   |
    /// | Reacts to NTP changes                  | ✅ No                                   |
    /// | Counts system suspension times         | ✅ No                                   |
    /// | Advances while process is de-scheduled | ✅ No                                   |
    /// | Might appear to go backwards           | ✅ No                                   |
    /// | Reads a cached value                   | ❌ Yes, for all threads                 |
    /// | Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
    /// | Warm read cost                         | ~ 145ns + up to ~ 10ns/thread @ 4GHz    |
    /// | Cold read cost                         | ~ 495ns @ 4GHz                          |
    /// | Step granularity                       | 1µs                                     |
    @inlinable
    public static var virtual: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_virtual)
    }

    /// `CLOCK_PROF`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures CPU time used by this process
    ///
    /// | Property                               | Value                                   |
    /// | -------------------------------------- | --------------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                                   |
    /// | Reacts to NTP changes                  | ✅ No                                   |
    /// | Counts system suspension times         | ✅ No                                   |
    /// | Advances while process is de-scheduled | ✅ No                                   |
    /// | Might appear to go backwards           | ✅ No                                   |
    /// | Reads a cached value                   | ❌ Yes, for all threads                 |
    /// | Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
    /// | Warm read cost                         | ~ 145ns + up to ~ 10ns/thread @ 4GHz    |
    /// | Cold read cost                         | ~ 560ns @ 4GHz                          |
    /// | Step granularity                       | 1µs                                     |
    @inlinable
    public static var prof: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_prof)
    }

    /// `CLOCK_SECOND`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures Wall time, whole seconds only
    ///
    /// | Property                              | Value          |
    /// | ------------------------------------- | -------------- |
    /// | Reacts to OS time changes             | ❌ Yes         |
    /// | Reacts to NTP changes                 | ❌ Yes         |
    /// | Counts system suspension times        | ❌ Yes         |
    /// | Advances while thread is de-scheduled | ❌ Yes         |
    /// | Might appear to go backwards          | ❌ Yes         |
    /// | Reads a cached value                  | ✅ No          |
    /// | Max staleness                         | ❌ ~ 1s        |
    /// | Warm read cost                        | ~ 18ns @ 4GHz  |
    /// | Cold read cost                        | ~ 265ns @ 4GHz |
    /// | Step granularity                      | 1s             |
    @inlinable
    public static var second: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_second)
    }

    /// `CLOCK_PROCESS_CPUTIME_ID`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
    ///
    /// Measures CPU time used by this process
    ///
    /// | Property                               | Value                                     |
    /// | -------------------------------------- | ----------------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                                     |
    /// | Reacts to NTP changes                  | ✅ No                                     |
    /// | Counts system suspension times         | ✅ No                                     |
    /// | Advances while process is de-scheduled | ✅ No                                     |
    /// | Might appear to go backwards           | ✅ No                                     |
    /// | Reads a cached value                   | ❌ Yes, for other threads                 |
    /// | Max staleness                          | ❌ ~ 8ms @ stathz 127, from other threads |
    /// | Warm read cost                         | ~ 145ns + ~ 11ns/thread @ 4GHz            |
    /// | Cold read cost                         | ~ 595ns @ 4GHz                            |
    /// | Step granularity                       | 170ns                                     |
    @inlinable
    public static var processCPUTime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_process_cpu_time)
    }

    /// `CLOCK_THREAD_CPUTIME_ID`
    ///
    /// [clock_gettime(2)](https://man.freebsd.org/cgi/man.cgi?query=clock_gettime&sektion=2)
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
    /// | Warm read cost                        | ~ 120ns @ 4GHz |
    /// | Cold read cost                        | ~ 495ns @ 4GHz |
    /// | Step granularity                      | 125ns          |
    @inlinable
    public static var threadCPUTime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_freebsd_thread_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time this process spent running its own code
    ///
    /// | Property                               | Value                                   |
    /// | -------------------------------------- | --------------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                                   |
    /// | Reacts to NTP changes                  | ✅ No                                   |
    /// | Counts system suspension times         | ✅ No                                   |
    /// | Advances while process is de-scheduled | ✅ No                                   |
    /// | Might appear to go backwards           | ✅ No                                   |
    /// | Reads a cached value                   | ❌ Yes, for all threads                 |
    /// | Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
    /// | Warm read cost                         | ~ 150ns + ~ 16ns/thread @ 4GHz          |
    /// | Cold read cost                         | ~ 490ns @ 4GHz                          |
    /// | Step granularity                       | 1µs                                     |
    @inlinable
    public static var processUserTime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_process_user_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_SELF`
    ///
    /// [getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time the kernel spent on this process's behalf
    ///
    /// | Property                               | Value                                   |
    /// | -------------------------------------- | --------------------------------------- |
    /// | Reacts to OS time changes              | ✅ No                                   |
    /// | Reacts to NTP changes                  | ✅ No                                   |
    /// | Counts system suspension times         | ✅ No                                   |
    /// | Advances while process is de-scheduled | ✅ No                                   |
    /// | Might appear to go backwards           | ✅ No                                   |
    /// | Reads a cached value                   | ❌ Yes, for all threads                 |
    /// | Max staleness                          | ❌ ~ 8ms @ stathz 127, from all threads |
    /// | Warm read cost                         | ~ 150ns + ~ 16ns/thread @ 4GHz          |
    /// | Cold read cost                         | ~ 490ns @ 4GHz                          |
    /// | Step granularity                       | 1µs                                     |
    @inlinable
    public static var processSystemTime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_process_system_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_THREAD`
    ///
    /// [getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time this thread spent running its own code
    ///
    /// | Property                              | Value                 |
    /// | ------------------------------------- | --------------------- |
    /// | Reacts to OS time changes             | ✅ No                 |
    /// | Reacts to NTP changes                 | ✅ No                 |
    /// | Counts system suspension times        | ✅ No                 |
    /// | Advances while thread is de-scheduled | ✅ No                 |
    /// | Might appear to go backwards          | ✅ No                 |
    /// | Reads a cached value                  | ❌ Yes                |
    /// | Max staleness                         | ❌ ~ 8ms @ stathz 127 |
    /// | Warm read cost                        | ~ 145ns @ 4GHz        |
    /// | Cold read cost                        | ~ 425ns @ 4GHz        |
    /// | Step granularity                      | 1µs                   |
    @inlinable
    public static var threadUserTime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_thread_user_cpu_time)
    }

    /// `getrusage(2)`, `RUSAGE_THREAD`
    ///
    /// [getrusage(2)](https://man.freebsd.org/cgi/man.cgi?query=getrusage&sektion=2)
    ///
    /// This is this library's own clock identifier and not one of the clock ids the platform declares.
    ///
    /// Measures CPU time the kernel spent on this thread's behalf
    ///
    /// | Property                              | Value                 |
    /// | ------------------------------------- | --------------------- |
    /// | Reacts to OS time changes             | ✅ No                 |
    /// | Reacts to NTP changes                 | ✅ No                 |
    /// | Counts system suspension times        | ✅ No                 |
    /// | Advances while thread is de-scheduled | ✅ No                 |
    /// | Might appear to go backwards          | ✅ No                 |
    /// | Reads a cached value                  | ❌ Yes                |
    /// | Max staleness                         | ❌ ~ 8ms @ stathz 127 |
    /// | Warm read cost                        | ~ 145ns @ 4GHz        |
    /// | Cold read cost                        | ~ 425ns @ 4GHz        |
    /// | Step granularity                      | 1µs                   |
    @inlinable
    public static var threadSystemTime: FreeBSDClockID {
        FreeBSDClockID(rawValue: csystem_clock_thread_system_cpu_time)
    }
}
