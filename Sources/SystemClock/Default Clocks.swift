@available(SwiftStdlib 5.7, *)
extension SystemClock {
    /// The time of day.
    ///
    /// Measures: Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ❌ Yes                                  |
    /// | Affected by NTP changes           | ❌ Yes                                  |
    /// | Affected by system suspension     | ❌ Yes                                  |
    /// | Affected by process de-scheduling | ❌ Yes                                  |
    /// | Appears to go backwards           | ❌ Yes                                  |
    /// | Reads a cached value              | ✅ No                                   |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                                |
    /// | -------------- | ------------------------------------ |
    /// | Darwin         | ``DarwinClockID/realtime``           |
    /// | Linux, Android | ``LinuxClockID/realtime``            |
    /// | Windows        | ``WindowsClockID/systemTimePrecise`` |
    /// | FreeBSD        | ``FreeBSDClockID/realtimePrecise``   |
    /// | OpenBSD        | ``OpenBSDClockID/realtime``          |
    /// | WASI           | ``WASIClockID/realtime``             |
    @inlinable
    public static var realtime: SystemClock {
        SystemClock(
            darwin: .realtime,
            linux: .realtime,
            windows: .systemTimePrecise,
            freebsd: .realtimePrecise,
            openbsd: .realtime,
            wasi: .realtime
        )
    }

    /// The time of day, read more cheaply.
    ///
    /// Measures: Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ❌ Yes                                  |
    /// | Affected by NTP changes           | ❌ Yes                                  |
    /// | Affected by system suspension     | ❌ Yes                                  |
    /// | Affected by process de-scheduling | ❌ Yes                                  |
    /// | Appears to go backwards           | ❌ Yes                                  |
    /// | Reads a cached value              | Varies by platform                      |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                           |
    /// | -------------- | ------------------------------- |
    /// | Darwin         | ``DarwinClockID/realtime``      |
    /// | Linux, Android | ``LinuxClockID/realtimeCoarse`` |
    /// | Windows        | ``WindowsClockID/systemTime``   |
    /// | FreeBSD        | ``FreeBSDClockID/realtimeFast`` |
    /// | OpenBSD        | ``OpenBSDClockID/realtime``     |
    /// | WASI           | ``WASIClockID/realtime``        |
    @inlinable
    public static var realtimeCoarse: SystemClock {
        SystemClock(
            darwin: .realtime,
            linux: .realtimeCoarse,
            windows: .systemTime,
            freebsd: .realtimeFast,
            openbsd: .realtime,
            wasi: .realtime
        )
    }

    /// A stopwatch that keeps running while the machine is asleep.
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ✅ No                                   |
    /// | Affected by NTP changes           | Varies by platform                      |
    /// | Affected by system suspension     | ❌ Yes                                  |
    /// | Affected by process de-scheduling | ❌ Yes                                  |
    /// | Appears to go backwards           | ✅ No                                   |
    /// | Reads a cached value              | ✅ No                                   |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                                   | Not affected by NTP |
    /// | -------------- | --------------------------------------- | ------------------- |
    /// | Darwin         | ``DarwinClockID/monotonicRaw``          | ✅                  |
    /// | Linux, Android | ``LinuxClockID/boottime``               | ❌                  |
    /// | Windows        | ``WindowsClockID/interruptTimePrecise`` | ✅                  |
    /// | FreeBSD        | ``FreeBSDClockID/monotonic``            | N/A                 |
    /// | OpenBSD        | ``OpenBSDClockID/boottime``             | N/A                 |
    /// | WASI           | ``WASIClockID/monotonic``               | ✅                  |
    @inlinable
    public static var continuous: SystemClock {
        SystemClock(
            darwin: .monotonicRaw,
            linux: .boottime,
            windows: .interruptTimePrecise,
            freebsd: .monotonic,
            openbsd: .boottime,
            wasi: .monotonic
        )
    }

    /// ``continuous``, read more cheaply.
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ✅ No                                   |
    /// | Affected by NTP changes           | Varies by platform                      |
    /// | Affected by system suspension     | ❌ Yes                                  |
    /// | Affected by process de-scheduling | ❌ Yes                                  |
    /// | Appears to go backwards           | ✅ No                                   |
    /// | Reads a cached value              | Varies by platform                      |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                                     |
    /// | -------------- | ----------------------------------------- |
    /// | Darwin         | ``DarwinClockID/monotonicRawApproximate`` |
    /// | Linux, Android | ``LinuxClockID/boottime``                 |
    /// | Windows        | ``WindowsClockID/interruptTime``          |
    /// | FreeBSD        | ``FreeBSDClockID/monotonicFast``          |
    /// | OpenBSD        | ``OpenBSDClockID/boottime``               |
    /// | WASI           | ``WASIClockID/monotonic``                 |
    @inlinable
    public static var continuousCoarse: SystemClock {
        SystemClock(
            darwin: .monotonicRawApproximate,
            linux: .boottime,
            windows: .interruptTime,
            freebsd: .monotonicFast,
            openbsd: .boottime,
            wasi: .monotonic
        )
    }

    /// A stopwatch that stops while the machine is asleep.
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ✅ No                                   |
    /// | Affected by NTP changes           | Varies by platform                      |
    /// | Affected by system suspension     | ✅ No                                   |
    /// | Affected by process de-scheduling | ❌ Yes                                  |
    /// | Appears to go backwards           | ✅ No                                   |
    /// | Reads a cached value              | ✅ No                                   |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                                           |
    /// | -------------- | ----------------------------------------------- |
    /// | Darwin         | ``DarwinClockID/uptimeRaw``                     |
    /// | Linux, Android | ``LinuxClockID/monotonic``                      |
    /// | Windows        | ``WindowsClockID/unbiasedInterruptTimePrecise`` |
    /// | FreeBSD        | ``FreeBSDClockID/uptime``                       |
    /// | OpenBSD        | ``OpenBSDClockID/uptime``                       |
    /// | WASI           | ``WASIClockID/monotonic``                       |
    @inlinable
    public static var suspending: SystemClock {
        SystemClock(
            darwin: .uptimeRaw,
            linux: .monotonic,
            windows: .unbiasedInterruptTimePrecise,
            freebsd: .uptime,
            openbsd: .uptime,
            wasi: .monotonic
        )
    }

    /// ``suspending``, read more cheaply.
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ✅ No                                   |
    /// | Affected by NTP changes           | Varies by platform                      |
    /// | Affected by system suspension     | ✅ No                                   |
    /// | Affected by process de-scheduling | ❌ Yes                                  |
    /// | Appears to go backwards           | ✅ No                                   |
    /// | Reads a cached value              | Varies by platform                      |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                                    |
    /// | -------------- | ---------------------------------------- |
    /// | Darwin         | ``DarwinClockID/uptimeRawApproximate``   |
    /// | Linux, Android | ``LinuxClockID/monotonicCoarse``         |
    /// | Windows        | ``WindowsClockID/unbiasedInterruptTime`` |
    /// | FreeBSD        | ``FreeBSDClockID/uptimeFast``            |
    /// | OpenBSD        | ``OpenBSDClockID/uptime``                |
    /// | WASI           | ``WASIClockID/monotonic``                |
    @inlinable
    public static var suspendingCoarse: SystemClock {
        SystemClock(
            darwin: .uptimeRawApproximate,
            linux: .monotonicCoarse,
            windows: .unbiasedInterruptTime,
            freebsd: .uptimeFast,
            openbsd: .uptime,
            wasi: .monotonic
        )
    }
}

@available(SwiftStdlib 5.7, *)
extension SystemClock {
    /// CPU time this process has used.
    ///
    /// WASI declares no cpu-time clock, and falls back to ``WASIClockID/monotonic``.
    ///
    /// Measures: CPU time used by this process
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ✅ No                                   |
    /// | Affected by NTP changes           | ✅ No                                   |
    /// | Affected by system suspension     | ✅ No                                   |
    /// | Affected by process de-scheduling | ✅ No                                   |
    /// | Appears to go backwards           | ✅ No                                   |
    /// | Reads a cached value              | ✅ No                                   |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                             |
    /// | -------------- | --------------------------------- |
    /// | Darwin         | ``DarwinClockID/processCPUTime``  |
    /// | Linux, Android | ``LinuxClockID/processCPUTime``   |
    /// | Windows        | ``WindowsClockID/processTime``    |
    /// | FreeBSD        | ``FreeBSDClockID/processCPUTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/processCPUTime`` |
    /// | WASI           | ``WASIClockID/monotonic``         |
    @inlinable
    public static var processCPUTime: SystemClock {
        SystemClock(
            darwin: .processCPUTime,
            linux: .processCPUTime,
            windows: .processTime,
            freebsd: .processCPUTime,
            openbsd: .processCPUTime,
            wasi: .monotonic
        )
    }

    /// CPU time the calling thread has used.
    ///
    /// WASI declares no cpu-time clock, and falls back to ``WASIClockID/monotonic``.
    ///
    /// Measures: CPU time used by this thread
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value                                   |
    /// | --------------------------------- | --------------------------------------- |
    /// | Affected by OS clock changes      | ✅ No                                   |
    /// | Affected by NTP changes           | ✅ No                                   |
    /// | Affected by system suspension     | ✅ No                                   |
    /// | Affected by process de-scheduling | ✅ No                                   |
    /// | Appears to go backwards           | ✅ No                                   |
    /// | Reads a cached value              | ✅ No                                   |
    /// | Possible staleness                | Varies by platform                      |
    /// | Typical read cost                 | Platform dependent; ~ 1.5-235ns @ 4GHz  |
    /// | Cold read cost                    | Platform dependent; ~ 135ns-22µs @ 4GHz |
    /// | Step granularity                  | Platform dependent; 42ns-15.6ms         |
    ///
    /// | Platform       | Clock                            |
    /// | -------------- | -------------------------------- |
    /// | Darwin         | ``DarwinClockID/threadCPUTime``  |
    /// | Linux, Android | ``LinuxClockID/threadCPUTime``   |
    /// | Windows        | ``WindowsClockID/threadTime``    |
    /// | FreeBSD        | ``FreeBSDClockID/threadCPUTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/threadCPUTime`` |
    /// | WASI           | ``WASIClockID/monotonic``        |
    @inlinable
    public static var threadCPUTime: SystemClock {
        SystemClock(
            darwin: .threadCPUTime,
            linux: .threadCPUTime,
            windows: .threadTime,
            freebsd: .threadCPUTime,
            openbsd: .threadCPUTime,
            wasi: .monotonic
        )
    }
}

@available(SwiftStdlib 5.7, *)
extension Clock where Self == SystemClock {
    /// ``SystemClock/realtime``.
    @inlinable
    public static var systemRealtime: SystemClock {
        SystemClock.realtime
    }

    /// ``SystemClock/realtimeCoarse``.
    @inlinable
    public static var systemRealtimeCoarse: SystemClock {
        SystemClock.realtimeCoarse
    }

    /// ``SystemClock/continuous``.
    @inlinable
    public static var systemContinuous: SystemClock {
        SystemClock.continuous
    }

    /// ``SystemClock/continuousCoarse``.
    @inlinable
    public static var systemContinuousCoarse: SystemClock {
        SystemClock.continuousCoarse
    }

    /// ``SystemClock/suspending``.
    @inlinable
    public static var systemSuspending: SystemClock {
        SystemClock.suspending
    }

    /// ``SystemClock/suspendingCoarse``.
    @inlinable
    public static var systemSuspendingCoarse: SystemClock {
        SystemClock.suspendingCoarse
    }

    /// ``SystemClock/processCPUTime``.
    @inlinable
    public static var systemProcessCPUTime: SystemClock {
        SystemClock.processCPUTime
    }

    /// ``SystemClock/threadCPUTime``.
    @inlinable
    public static var systemThreadCPUTime: SystemClock {
        SystemClock.threadCPUTime
    }
}
