public import CSystemClock

/// One of the Win32 time functions.
///
/// Windows has no `clockid_t`, so `rawValue` is this library's own arbitrary identifier for the clock.
public struct WindowsClockID: Sendable, Hashable, RawRepresentable {
    public let rawValue: Int32

    @inlinable
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

extension WindowsClockID {
    /// `QueryPerformanceCounter`
    ///
    /// [QueryPerformanceCounter](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter)
    ///
    /// Measures Elapsed time, since the machine booted
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
    /// | Warm read cost                        | ~ 10ns @ 4GHz  |
    /// | Cold read cost                        | ~ 230ns @ 4GHz |
    /// | Step granularity                      | 100ns          |
    @inlinable
    public static var performanceCounter: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_performance_counter)
    }

    /// `GetSystemTimeAsFileTime`
    ///
    /// [GetSystemTimeAsFileTime](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtimeasfiletime)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// | Property                              | Value                |
    /// | ------------------------------------- | -------------------- |
    /// | Reacts to OS time changes             | ❌ Yes                |
    /// | Reacts to NTP changes                 | ❌ Yes                |
    /// | Counts system suspension times        | ❌ Yes                |
    /// | Advances while thread is de-scheduled | ❌ Yes                |
    /// | Might appear to go backwards          | ❌ Yes                |
    /// | Reads a cached value                  | ❌ Yes                |
    /// | Max staleness                         | ❌ ~ 16ms @ 64Hz tick |
    /// | Warm read cost                        | ~ 4ns @ 4GHz         |
    /// | Cold read cost                        | ~ 1.5µs @ 4GHz       |
    /// | Step granularity                      | ~ 0.5ms              |
    @inlinable
    public static var systemTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_system_time)
    }

    /// `GetSystemTimePreciseAsFileTime`
    ///
    /// [GetSystemTimePreciseAsFileTime](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtimepreciseasfiletime)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// | Property                              | Value         |
    /// | ------------------------------------- | ------------- |
    /// | Reacts to OS time changes             | ❌ Yes        |
    /// | Reacts to NTP changes                 | ❌ Yes        |
    /// | Counts system suspension times        | ❌ Yes        |
    /// | Advances while thread is de-scheduled | ❌ Yes        |
    /// | Might appear to go backwards          | ❌ Yes        |
    /// | Reads a cached value                  | ✅ No         |
    /// | Max staleness                         | ✅ None       |
    /// | Warm read cost                        | ~ 16ns @ 4GHz |
    /// | Cold read cost                        | ~ 2µs @ 4GHz  |
    /// | Step granularity                      | 100ns         |
    @inlinable
    public static var systemTimePrecise: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_system_time_precise)
    }

    /// `QueryInterruptTime`
    ///
    /// [QueryInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttime)
    ///
    /// Measures Elapsed time, since the machine booted
    ///
    /// | Property                              | Value                |
    /// | ------------------------------------- | -------------------- |
    /// | Reacts to OS time changes             | ✅ No                 |
    /// | Reacts to NTP changes                 | ✅ No                 |
    /// | Counts system suspension times        | ❌ Yes                |
    /// | Advances while thread is de-scheduled | ❌ Yes                |
    /// | Might appear to go backwards          | ✅ No                 |
    /// | Reads a cached value                  | ❌ Yes                |
    /// | Max staleness                         | ❌ ~ 16ms @ 64Hz tick |
    /// | Warm read cost                        | ~ 2ns @ 4GHz         |
    /// | Cold read cost                        | ~ 1.9µs @ 4GHz       |
    /// | Step granularity                      | ~ 0.5ms              |
    @inlinable
    public static var interruptTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_interrupt_time)
    }

    /// `QueryInterruptTimePrecise`
    ///
    /// [QueryInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttimeprecise)
    ///
    /// Measures Elapsed time, since the machine booted
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
    /// | Warm read cost                        | ~ 14ns @ 4GHz  |
    /// | Cold read cost                        | ~ 330ns @ 4GHz |
    /// | Step granularity                      | 100ns          |
    @inlinable
    public static var interruptTimePrecise: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_interrupt_time_precise)
    }

    /// `QueryUnbiasedInterruptTime`
    ///
    /// [QueryUnbiasedInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttime)
    ///
    /// Measures Elapsed time, since the machine booted
    ///
    /// | Property                              | Value                |
    /// | ------------------------------------- | -------------------- |
    /// | Reacts to OS time changes             | ✅ No                 |
    /// | Reacts to NTP changes                 | ✅ No                 |
    /// | Counts system suspension times        | ✅ No                 |
    /// | Advances while thread is de-scheduled | ❌ Yes                |
    /// | Might appear to go backwards          | ✅ No                 |
    /// | Reads a cached value                  | ❌ Yes                |
    /// | Max staleness                         | ❌ ~ 16ms @ 64Hz tick |
    /// | Warm read cost                        | ~ 3ns @ 4GHz         |
    /// | Cold read cost                        | ~ 1.9µs @ 4GHz       |
    /// | Step granularity                      | ~ 0.5ms              |
    @inlinable
    public static var unbiasedInterruptTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_unbiased_interrupt_time)
    }

    /// `QueryUnbiasedInterruptTimePrecise`
    ///
    /// [QueryUnbiasedInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttimeprecise)
    ///
    /// Measures Elapsed time, since the machine booted
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
    /// | Warm read cost                        | ~ 14ns @ 4GHz  |
    /// | Cold read cost                        | ~ 2.3µs @ 4GHz |
    /// | Step granularity                      | 100ns          |
    @inlinable
    public static var unbiasedInterruptTimePrecise: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_unbiased_interrupt_time_precise)
    }

    /// `GetTickCount64`
    ///
    /// [GetTickCount64](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-gettickcount64)
    ///
    /// Measures Elapsed time, since the machine booted
    ///
    /// | Property                              | Value                |
    /// | ------------------------------------- | -------------------- |
    /// | Reacts to OS time changes             | ✅ No                 |
    /// | Reacts to NTP changes                 | ✅ No                 |
    /// | Counts system suspension times        | ❌ Yes                |
    /// | Advances while thread is de-scheduled | ❌ Yes                |
    /// | Might appear to go backwards          | ✅ No                 |
    /// | Reads a cached value                  | ❌ Yes                |
    /// | Max staleness                         | ❌ ~ 18ms @ 64Hz tick |
    /// | Warm read cost                        | ~ 1.5ns @ 4GHz       |
    /// | Cold read cost                        | ~ 1.8µs @ 4GHz       |
    /// | Step granularity                      | 15ms                 |
    @inlinable
    public static var tickCount: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_tick_count)
    }

    /// `GetProcessTimes`
    ///
    /// [GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)
    ///
    /// Measures CPU time used by this process
    ///
    /// | Property                              | Value                               |
    /// | ------------------------------------- | ----------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                               |
    /// | Reacts to NTP changes                 | ✅ No                               |
    /// | Counts system suspension times        | ✅ No                               |
    /// | Advances while thread is de-scheduled | ✅ No                               |
    /// | Might appear to go backwards          | ✅ No                               |
    /// | Reads a cached value                  | ❌ Yes                              |
    /// | Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick             |
    /// | Warm read cost                        | ~ 120ns + up to ~ 8ns/thread @ 4GHz |
    /// | Cold read cost                        | ~ 2.6µs @ 4GHz                      |
    /// | Step granularity                      | 15.625ms @ 64Hz tick                |
    @inlinable
    public static var processTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_process_time)
    }

    /// `GetThreadTimes`
    ///
    /// [GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)
    ///
    /// Measures CPU time used by this thread
    ///
    /// | Property                              | Value                  |
    /// | ------------------------------------- | ---------------------- |
    /// | Reacts to OS time changes             | ✅ No                   |
    /// | Reacts to NTP changes                 | ✅ No                   |
    /// | Counts system suspension times        | ✅ No                   |
    /// | Advances while thread is de-scheduled | ✅ No                   |
    /// | Might appear to go backwards          | ✅ No                   |
    /// | Reads a cached value                  | ❌ Yes                  |
    /// | Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick |
    /// | Warm read cost                        | ~ 86ns @ 4GHz          |
    /// | Cold read cost                        | ~ 585ns @ 4GHz         |
    /// | Step granularity                      | 15.625ms @ 64Hz tick   |
    @inlinable
    public static var threadTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_thread_time)
    }

    /// `GetProcessTimes`
    ///
    /// [GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)
    ///
    /// One half of the pair `GetProcessTimes` reports; `processTime` and `threadTime` read them summed.
    ///
    /// Measures CPU time this process spent running its own code
    ///
    /// | Property                              | Value                               |
    /// | ------------------------------------- | ----------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                               |
    /// | Reacts to NTP changes                 | ✅ No                               |
    /// | Counts system suspension times        | ✅ No                               |
    /// | Advances while thread is de-scheduled | ✅ No                               |
    /// | Might appear to go backwards          | ✅ No                               |
    /// | Reads a cached value                  | ❌ Yes                              |
    /// | Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick             |
    /// | Warm read cost                        | ~ 113ns + up to ~ 8ns/thread @ 4GHz |
    /// | Cold read cost                        | ~ 2.7µs @ 4GHz                      |
    /// | Step granularity                      | 15.625ms @ 64Hz tick                |
    @inlinable
    public static var processUserTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_process_user_cpu_time)
    }

    /// `GetProcessTimes`
    ///
    /// [GetProcessTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes)
    ///
    /// One half of the pair `GetProcessTimes` reports; `processTime` and `threadTime` read them summed.
    ///
    /// Measures CPU time the kernel spent on this process's behalf
    ///
    /// | Property                              | Value                               |
    /// | ------------------------------------- | ----------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                               |
    /// | Reacts to NTP changes                 | ✅ No                               |
    /// | Counts system suspension times        | ✅ No                               |
    /// | Advances while thread is de-scheduled | ✅ No                               |
    /// | Might appear to go backwards          | ✅ No                               |
    /// | Reads a cached value                  | ❌ Yes                              |
    /// | Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick             |
    /// | Warm read cost                        | ~ 115ns + up to ~ 8ns/thread @ 4GHz |
    /// | Cold read cost                        | ~ 2.8µs @ 4GHz                      |
    /// | Step granularity                      | 15.625ms @ 64Hz tick                |
    @inlinable
    public static var processKernelTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_process_system_cpu_time)
    }

    /// `GetThreadTimes`
    ///
    /// [GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)
    ///
    /// One half of the pair `GetThreadTimes` reports; `processTime` and `threadTime` read them summed.
    ///
    /// Measures CPU time this thread spent running its own code
    ///
    /// | Property                              | Value                  |
    /// | ------------------------------------- | ---------------------- |
    /// | Reacts to OS time changes             | ✅ No                   |
    /// | Reacts to NTP changes                 | ✅ No                   |
    /// | Counts system suspension times        | ✅ No                   |
    /// | Advances while thread is de-scheduled | ✅ No                   |
    /// | Might appear to go backwards          | ✅ No                   |
    /// | Reads a cached value                  | ❌ Yes                  |
    /// | Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick |
    /// | Warm read cost                        | ~ 87ns @ 4GHz          |
    /// | Cold read cost                        | ~ 610ns @ 4GHz         |
    /// | Step granularity                      | 15.625ms @ 64Hz tick   |
    @inlinable
    public static var threadUserTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_thread_user_cpu_time)
    }

    /// `GetThreadTimes`
    ///
    /// [GetThreadTimes](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes)
    ///
    /// One half of the pair `GetThreadTimes` reports; `processTime` and `threadTime` read them summed.
    ///
    /// Measures CPU time the kernel spent on this thread's behalf
    ///
    /// | Property                              | Value                  |
    /// | ------------------------------------- | ---------------------- |
    /// | Reacts to OS time changes             | ✅ No                   |
    /// | Reacts to NTP changes                 | ✅ No                   |
    /// | Counts system suspension times        | ✅ No                   |
    /// | Advances while thread is de-scheduled | ✅ No                   |
    /// | Might appear to go backwards          | ✅ No                   |
    /// | Reads a cached value                  | ❌ Yes                  |
    /// | Max staleness                         | ❌ ~ 15.6ms @ 64Hz tick |
    /// | Warm read cost                        | ~ 87ns @ 4GHz          |
    /// | Cold read cost                        | ~ 630ns @ 4GHz         |
    /// | Step granularity                      | 15.625ms @ 64Hz tick   |
    @inlinable
    public static var threadKernelTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_thread_system_cpu_time)
    }
}
