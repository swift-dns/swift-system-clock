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
    /// Measures Elapsed time, since the machine started
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
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
    /// | Typical read cost                 | ~ 10ns @ 4GHz  |
    /// | Cold read cost                    | ~ 230ns @ 4GHz |
    /// | Step granularity                  | 100ns          |
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
    /// | Typical read cost                 | ~ 4ns @ 4GHz   |
    /// | Cold read cost                    | ~ 1.5µs @ 4GHz |
    /// | Step granularity                  | ~ 1ms          |
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
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value         |
    /// | --------------------------------- | ------------- |
    /// | Affected by OS clock changes      | ❌ Yes        |
    /// | Affected by NTP changes           | ❌ Yes        |
    /// | Affected by system suspension     | ❌ Yes        |
    /// | Affected by process de-scheduling | ❌ Yes        |
    /// | Appears to go backwards           | ❌ Yes        |
    /// | Reads a cached value              | ✅ No         |
    /// | Possible staleness                | ✅ None       |
    /// | Typical read cost                 | ~ 16ns @ 4GHz |
    /// | Cold read cost                    | ~ 2µs @ 4GHz  |
    /// | Step granularity                  | 100ns         |
    @inlinable
    public static var systemTimePrecise: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_system_time_precise)
    }

    /// `QueryInterruptTime`
    ///
    /// [QueryInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttime)
    ///
    /// Measures Elapsed time, since the machine started
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ❌ Yes         |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 2ms       |
    /// | Typical read cost                 | ~ 2ns @ 4GHz   |
    /// | Cold read cost                    | ~ 1.9µs @ 4GHz |
    /// | Step granularity                  | ~ 1ms          |
    @inlinable
    public static var interruptTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_interrupt_time)
    }

    /// `QueryInterruptTimePrecise`
    ///
    /// [QueryInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryinterrupttimeprecise)
    ///
    /// Measures Elapsed time, since the machine started
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
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
    /// | Typical read cost                 | ~ 14ns @ 4GHz  |
    /// | Cold read cost                    | ~ 330ns @ 4GHz |
    /// | Step granularity                  | 100ns          |
    @inlinable
    public static var interruptTimePrecise: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_interrupt_time_precise)
    }

    /// `QueryUnbiasedInterruptTime`
    ///
    /// [QueryUnbiasedInterruptTime](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttime)
    ///
    /// Measures Elapsed time, since the machine started
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ✅ No          |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 2ms       |
    /// | Typical read cost                 | ~ 3ns @ 4GHz   |
    /// | Cold read cost                    | ~ 1.9µs @ 4GHz |
    /// | Step granularity                  | ~ 1ms          |
    @inlinable
    public static var unbiasedInterruptTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_unbiased_interrupt_time)
    }

    /// `QueryUnbiasedInterruptTimePrecise`
    ///
    /// [QueryUnbiasedInterruptTimePrecise](https://learn.microsoft.com/en-us/windows/win32/api/realtimeapiset/nf-realtimeapiset-queryunbiasedinterrupttimeprecise)
    ///
    /// Measures Elapsed time, since the machine started
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
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
    /// | Typical read cost                 | ~ 14ns @ 4GHz  |
    /// | Cold read cost                    | ~ 280ns @ 4GHz |
    /// | Step granularity                  | 100ns          |
    @inlinable
    public static var unbiasedInterruptTimePrecise: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_unbiased_interrupt_time_precise)
    }

    /// `GetTickCount64`
    ///
    /// [GetTickCount64](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-gettickcount64)
    ///
    /// Measures Elapsed time, since the machine started
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value          |
    /// | --------------------------------- | -------------- |
    /// | Affected by OS clock changes      | ✅ No          |
    /// | Affected by NTP changes           | ✅ No          |
    /// | Affected by system suspension     | ❌ Yes         |
    /// | Affected by process de-scheduling | ❌ Yes         |
    /// | Appears to go backwards           | ✅ No          |
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 18ms      |
    /// | Typical read cost                 | ~ 1.5ns @ 4GHz |
    /// | Cold read cost                    | ~ 1.4µs @ 4GHz |
    /// | Step granularity                  | 15ms           |
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
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 15.6ms    |
    /// | Typical read cost                 | ~ 120ns @ 4GHz |
    /// | Cold read cost                    | ~ 2.6µs @ 4GHz |
    /// | Step granularity                  | 15.625ms       |
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
    /// | Reads a cached value              | ❌ Yes         |
    /// | Possible staleness                | ❌ ~ 15.6ms    |
    /// | Typical read cost                 | ~ 86ns @ 4GHz  |
    /// | Cold read cost                    | ~ 585ns @ 4GHz |
    /// | Step granularity                  | 15.625ms       |
    @inlinable
    public static var threadTime: WindowsClockID {
        WindowsClockID(rawValue: csystem_clock_windows_thread_time)
    }
}
