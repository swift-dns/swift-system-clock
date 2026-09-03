@available(SwiftStdlib 5.7, *)
@_unavailableInEmbedded
extension GenericSystemClock {
    /// The time of day.
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// | Property                              | Value                                     |
    /// | ------------------------------------- | ----------------------------------------- |
    /// | Reacts to OS time changes             | ❌ Yes                                    |
    /// | Reacts to NTP changes                 | ❌ Yes                                    |
    /// | Counts system suspension times        | ❌ Yes                                    |
    /// | Advances while thread is de-scheduled | ❌ Yes                                    |
    /// | Might appear to go backwards          | ❌ Yes                                    |
    /// | Reads a cached value                  | ✅ No                                     |
    /// | Max staleness                         | Varies by platform                        |
    /// | Warm read cost                        | Platform dependent; ~ 12-57ns @ 4GHz      |
    /// | Cold read cost                        | Platform dependent; ~ 200ns-19.7µs @ 4GHz |
    /// | Step granularity                      | Platform dependent; 20ns-1µs              |
    ///
    /// | Platform       | Clock                                |
    /// | -------------- | ------------------------------------ |
    /// | Darwin         | ``DarwinClockID/realtime``           |
    /// | Linux, Android | ``LinuxClockID/realtime``            |
    /// | Windows        | ``WindowsClockID/systemTimePrecise`` |
    /// | FreeBSD        | ``FreeBSDClockID/realtimePrecise``   |
    /// | OpenBSD        | ``OpenBSDClockID/realtime``          |
    /// | WASI           | ``WASIClockID/realtime``             |
    /// | Fallback       | ``STDChronoClockID/realtime``        |
    @inlinable
    public static var realtime: GenericSystemClock {
        GenericSystemClock(
            darwin: .realtime,
            linux: .realtime,
            windows: .systemTimePrecise,
            freebsd: .realtimePrecise,
            openbsd: .realtime,
            wasi: .realtime,
            fallback: .realtime
        )
    }

    /// The time of day, read more cheaply.
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// | Property                              | Value                                     |
    /// | ------------------------------------- | ----------------------------------------- |
    /// | Reacts to OS time changes             | ❌ Yes                                    |
    /// | Reacts to NTP changes                 | ❌ Yes                                    |
    /// | Counts system suspension times        | ❌ Yes                                    |
    /// | Advances while thread is de-scheduled | ❌ Yes                                    |
    /// | Might appear to go backwards          | ❌ Yes                                    |
    /// | Reads a cached value                  | Varies by platform                        |
    /// | Max staleness                         | Varies by platform                        |
    /// | Warm read cost                        | Platform dependent; ~ 4-57ns @ 4GHz       |
    /// | Cold read cost                        | Platform dependent; ~ 200ns-19.7µs @ 4GHz |
    /// | Step granularity                      | Platform dependent; 42ns-1ms              |
    ///
    /// | Platform       | Clock                           |
    /// | -------------- | ------------------------------- |
    /// | Darwin         | ``DarwinClockID/realtime``      |
    /// | Linux, Android | ``LinuxClockID/realtimeCoarse`` |
    /// | Windows        | ``WindowsClockID/systemTime``   |
    /// | FreeBSD        | ``FreeBSDClockID/realtimeFast`` |
    /// | OpenBSD        | ``OpenBSDClockID/realtime``     |
    /// | WASI           | ``WASIClockID/realtime``        |
    /// | Fallback       | ``STDChronoClockID/realtime``   |
    @inlinable
    public static var realtimeCoarse: GenericSystemClock {
        GenericSystemClock(
            darwin: .realtime,
            linux: .realtimeCoarse,
            windows: .systemTime,
            freebsd: .realtimeFast,
            openbsd: .realtime,
            wasi: .realtime,
            fallback: .realtime
        )
    }

    /// A stopwatch that keeps running while the machine is asleep.
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                                     |
    /// | ------------------------------------- | ----------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                     |
    /// | Reacts to NTP changes                 | Varies by platform                        |
    /// | Counts system suspension times        | Varies by platform                        |
    /// | Advances while thread is de-scheduled | ❌ Yes                                    |
    /// | Might appear to go backwards          | ✅ No                                     |
    /// | Reads a cached value                  | ✅ No                                     |
    /// | Max staleness                         | Varies by platform                        |
    /// | Warm read cost                        | Platform dependent; ~ 13-56ns @ 4GHz      |
    /// | Cold read cost                        | Platform dependent; ~ 135ns-18.2µs @ 4GHz |
    /// | Step granularity                      | Platform dependent; 20-100ns              |
    ///
    /// | Platform       | Clock                                   | Not affected by NTP |
    /// | -------------- | --------------------------------------- | ------------------- |
    /// | Darwin         | ``DarwinClockID/monotonicRaw``          | ✅                  |
    /// | Linux, Android | ``LinuxClockID/boottime``               | ❌                  |
    /// | Windows        | ``WindowsClockID/interruptTimePrecise`` | ✅                  |
    /// | FreeBSD        | ``FreeBSDClockID/monotonic``            | ❌                  |
    /// | OpenBSD        | ``OpenBSDClockID/boottime``             | ❌                  |
    /// | WASI           | ``WASIClockID/monotonic``               | ✅                  |
    /// | Fallback       | ``STDChronoClockID/monotonic``          | ❌                  |
    @inlinable
    public static var continuous: GenericSystemClock {
        GenericSystemClock(
            darwin: .monotonicRaw,
            linux: .boottime,
            windows: .interruptTimePrecise,
            freebsd: .monotonic,
            openbsd: .boottime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// ``continuous``, read more cheaply.
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                                     |
    /// | ------------------------------------- | ----------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                     |
    /// | Reacts to NTP changes                 | Varies by platform                        |
    /// | Counts system suspension times        | Varies by platform                        |
    /// | Advances while thread is de-scheduled | ❌ Yes                                    |
    /// | Might appear to go backwards          | ✅ No                                     |
    /// | Reads a cached value                  | Varies by platform                        |
    /// | Max staleness                         | Varies by platform                        |
    /// | Warm read cost                        | Platform dependent; ~ 2-56ns @ 4GHz       |
    /// | Cold read cost                        | Platform dependent; ~ 230ns-18.2µs @ 4GHz |
    /// | Step granularity                      | Platform dependent; 20ns-1ms              |
    ///
    /// | Platform       | Clock                                     |
    /// | -------------- | ----------------------------------------- |
    /// | Darwin         | ``DarwinClockID/monotonicRawApproximate`` |
    /// | Linux, Android | ``LinuxClockID/boottime``                 |
    /// | Windows        | ``WindowsClockID/interruptTime``          |
    /// | FreeBSD        | ``FreeBSDClockID/monotonicFast``          |
    /// | OpenBSD        | ``OpenBSDClockID/boottime``               |
    /// | WASI           | ``WASIClockID/monotonic``                 |
    /// | Fallback       | ``STDChronoClockID/monotonic``            |
    @inlinable
    public static var continuousCoarse: GenericSystemClock {
        GenericSystemClock(
            darwin: .monotonicRawApproximate,
            linux: .boottime,
            windows: .interruptTime,
            freebsd: .monotonicFast,
            openbsd: .boottime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// A stopwatch that stops while the machine is asleep.
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                                           |
    /// | ------------------------------------- | ----------------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                           |
    /// | Reacts to NTP changes                 | Varies by platform                              |
    /// | Counts system suspension times        | ✅ No, but runtime-dependent on WASI & Fallback |
    /// | Advances while thread is de-scheduled | ❌ Yes                                          |
    /// | Might appear to go backwards          | ✅ No                                           |
    /// | Reads a cached value                  | ✅ No                                           |
    /// | Max staleness                         | Varies by platform                              |
    /// | Warm read cost                        | Platform dependent; ~ 13-56ns @ 4GHz            |
    /// | Cold read cost                        | Platform dependent; ~ 165ns-15.9µs @ 4GHz       |
    /// | Step granularity                      | Platform dependent; 20-100ns                    |
    ///
    /// | Platform       | Clock                                           |
    /// | -------------- | ----------------------------------------------- |
    /// | Darwin         | ``DarwinClockID/uptimeRaw``                     |
    /// | Linux, Android | ``LinuxClockID/monotonic``                      |
    /// | Windows        | ``WindowsClockID/unbiasedInterruptTimePrecise`` |
    /// | FreeBSD        | ``FreeBSDClockID/uptime``                       |
    /// | OpenBSD        | ``OpenBSDClockID/uptime``                       |
    /// | WASI           | ``WASIClockID/monotonic``                       |
    /// | Fallback       | ``STDChronoClockID/monotonic``                  |
    @inlinable
    public static var suspending: GenericSystemClock {
        GenericSystemClock(
            darwin: .uptimeRaw,
            linux: .monotonic,
            windows: .unbiasedInterruptTimePrecise,
            freebsd: .uptime,
            openbsd: .uptime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// ``suspending``, read more cheaply.
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                                           |
    /// | ------------------------------------- | ----------------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                           |
    /// | Reacts to NTP changes                 | Varies by platform                              |
    /// | Counts system suspension times        | ✅ No, but runtime-dependent on WASI & Fallback |
    /// | Advances while thread is de-scheduled | ❌ Yes                                          |
    /// | Might appear to go backwards          | ✅ No                                           |
    /// | Reads a cached value                  | Varies by platform                              |
    /// | Max staleness                         | Varies by platform                              |
    /// | Warm read cost                        | Platform dependent; ~ 3-56ns @ 4GHz             |
    /// | Cold read cost                        | Platform dependent; ~ 165ns-15.9µs @ 4GHz       |
    /// | Step granularity                      | Platform dependent; 42ns-1ms                    |
    ///
    /// | Platform       | Clock                                    |
    /// | -------------- | ---------------------------------------- |
    /// | Darwin         | ``DarwinClockID/uptimeRawApproximate``   |
    /// | Linux, Android | ``LinuxClockID/monotonicCoarse``         |
    /// | Windows        | ``WindowsClockID/unbiasedInterruptTime`` |
    /// | FreeBSD        | ``FreeBSDClockID/uptimeFast``            |
    /// | OpenBSD        | ``OpenBSDClockID/uptime``                |
    /// | WASI           | ``WASIClockID/monotonic``                |
    /// | Fallback       | ``STDChronoClockID/monotonic``           |
    @inlinable
    public static var suspendingCoarse: GenericSystemClock {
        GenericSystemClock(
            darwin: .uptimeRawApproximate,
            linux: .monotonicCoarse,
            windows: .unbiasedInterruptTime,
            freebsd: .uptimeFast,
            openbsd: .uptime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }
}

@available(SwiftStdlib 5.7, *)
@_unavailableInEmbedded
extension GenericSystemClock {
    /// CPU time this process has used.
    ///
    /// Neither wasi-libc nor `<chrono>` has a cpu-time clock, so both fall back to `monotonic`.
    ///
    /// Measures CPU time used by this process
    ///
    /// | Property                              | Value                                                       |
    /// | ------------------------------------- | ----------------------------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                                       |
    /// | Reacts to NTP changes                 | ✅ No                                                       |
    /// | Counts system suspension times        | ✅ No                                                       |
    /// | Advances while thread is de-scheduled | Varies by platform                                          |
    /// | Might appear to go backwards          | ✅ No                                                       |
    /// | Reads a cached value                  | Varies by platform                                          |
    /// | Max staleness                         | Varies by platform                                          |
    /// | Warm read cost                        | Platform dependent; ~ 56-235ns + up to ~ 11ns/thread @ 4GHz |
    /// | Cold read cost                        | Platform dependent; ~ 595ns-15.4µs @ 4GHz                   |
    /// | Step granularity                      | Platform dependent; 42ns-15.6ms                             |
    ///
    /// | Platform       | Clock                             |
    /// | -------------- | --------------------------------- |
    /// | Darwin         | ``DarwinClockID/processCPUTime``  |
    /// | Linux, Android | ``LinuxClockID/processCPUTime``   |
    /// | Windows        | ``WindowsClockID/processTime``    |
    /// | FreeBSD        | ``FreeBSDClockID/processCPUTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/processCPUTime`` |
    /// | WASI           | ``WASIClockID/monotonic``         |
    /// | Fallback       | ``STDChronoClockID/monotonic``    |
    @inlinable
    public static var processCPUTime: GenericSystemClock {
        GenericSystemClock(
            darwin: .processCPUTime,
            linux: .processCPUTime,
            windows: .processTime,
            freebsd: .processCPUTime,
            openbsd: .processCPUTime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// CPU time the calling thread has used.
    ///
    /// Neither wasi-libc nor `<chrono>` has a cpu-time clock, so both fall back to `monotonic`.
    ///
    /// Measures CPU time used by this thread
    ///
    /// | Property                              | Value                                     |
    /// | ------------------------------------- | ----------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                     |
    /// | Reacts to NTP changes                 | ✅ No                                     |
    /// | Counts system suspension times        | ✅ No                                     |
    /// | Advances while thread is de-scheduled | Varies by platform                        |
    /// | Might appear to go backwards          | ✅ No                                     |
    /// | Reads a cached value                  | Varies by platform                        |
    /// | Max staleness                         | Varies by platform                        |
    /// | Warm read cost                        | Platform dependent; ~ 56-195ns @ 4GHz     |
    /// | Cold read cost                        | Platform dependent; ~ 460ns-15.5µs @ 4GHz |
    /// | Step granularity                      | Platform dependent; 42ns-15.6ms           |
    ///
    /// | Platform       | Clock                            |
    /// | -------------- | -------------------------------- |
    /// | Darwin         | ``DarwinClockID/threadCPUTime``  |
    /// | Linux, Android | ``LinuxClockID/threadCPUTime``   |
    /// | Windows        | ``WindowsClockID/threadTime``    |
    /// | FreeBSD        | ``FreeBSDClockID/threadCPUTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/threadCPUTime`` |
    /// | WASI           | ``WASIClockID/monotonic``        |
    /// | Fallback       | ``STDChronoClockID/monotonic``   |
    @inlinable
    public static var threadCPUTime: GenericSystemClock {
        GenericSystemClock(
            darwin: .threadCPUTime,
            linux: .threadCPUTime,
            windows: .threadTime,
            freebsd: .threadCPUTime,
            openbsd: .threadCPUTime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// CPU time this process has used running its own code.
    ///
    /// Not a clock id the platform declares: this library's own, selecting one half of one call.
    ///
    /// Neither wasi-libc nor `<chrono>` has a cpu-time clock, so both fall back to `monotonic`.
    ///
    /// Measures CPU time this process spent running its own code
    ///
    /// | Property                              | Value                                                       |
    /// | ------------------------------------- | ----------------------------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                                       |
    /// | Reacts to NTP changes                 | ✅ No                                                       |
    /// | Counts system suspension times        | ✅ No                                                       |
    /// | Advances while thread is de-scheduled | Varies by platform                                          |
    /// | Might appear to go backwards          | ✅ No                                                       |
    /// | Reads a cached value                  | Varies by platform                                          |
    /// | Max staleness                         | Varies by platform                                          |
    /// | Warm read cost                        | Platform dependent; ~ 56-220ns + up to ~ 16ns/thread @ 4GHz |
    /// | Cold read cost                        | Platform dependent; ~ 490ns-5µs @ 4GHz                      |
    /// | Step granularity                      | Platform dependent; 42ns-15.6ms                             |
    ///
    /// | Platform       | Clock                              |
    /// | -------------- | ---------------------------------- |
    /// | Darwin         | ``DarwinClockID/processUserTime``  |
    /// | Linux, Android | ``LinuxClockID/processUserTime``   |
    /// | Windows        | ``WindowsClockID/processUserTime`` |
    /// | FreeBSD        | ``FreeBSDClockID/processUserTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/processUserTime`` |
    /// | WASI           | ``WASIClockID/monotonic``          |
    /// | Fallback       | ``STDChronoClockID/monotonic``     |
    @inlinable
    public static var processUserTime: GenericSystemClock {
        GenericSystemClock(
            darwin: .processUserTime,
            linux: .processUserTime,
            windows: .processUserTime,
            freebsd: .processUserTime,
            openbsd: .processUserTime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// CPU time the kernel has used on this process's behalf.
    ///
    /// Neither wasi-libc nor `<chrono>` has a cpu-time clock, so both fall back to `monotonic`.
    ///
    /// Measures CPU time the kernel spent on this process's behalf
    ///
    /// | Property                              | Value                                                       |
    /// | ------------------------------------- | ----------------------------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                                       |
    /// | Reacts to NTP changes                 | ✅ No                                                       |
    /// | Counts system suspension times        | ✅ No                                                       |
    /// | Advances while thread is de-scheduled | Varies by platform                                          |
    /// | Might appear to go backwards          | ✅ No                                                       |
    /// | Reads a cached value                  | Varies by platform                                          |
    /// | Max staleness                         | Varies by platform                                          |
    /// | Warm read cost                        | Platform dependent; ~ 56-220ns + up to ~ 16ns/thread @ 4GHz |
    /// | Cold read cost                        | Platform dependent; ~ 490ns-5µs @ 4GHz                      |
    /// | Step granularity                      | Platform dependent; 42ns-15.6ms                             |
    ///
    /// | Platform       | Clock                                |
    /// | -------------- | ------------------------------------ |
    /// | Darwin         | ``DarwinClockID/processSystemTime``  |
    /// | Linux, Android | ``LinuxClockID/processSystemTime``   |
    /// | Windows        | ``WindowsClockID/processKernelTime`` |
    /// | FreeBSD        | ``FreeBSDClockID/processSystemTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/processSystemTime`` |
    /// | WASI           | ``WASIClockID/monotonic``            |
    /// | Fallback       | ``STDChronoClockID/monotonic``       |
    @inlinable
    public static var processSystemTime: GenericSystemClock {
        GenericSystemClock(
            darwin: .processSystemTime,
            linux: .processSystemTime,
            windows: .processKernelTime,
            freebsd: .processSystemTime,
            openbsd: .processSystemTime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// CPU time the calling thread has used running its own code.
    ///
    /// Neither wasi-libc nor `<chrono>` has a cpu-time clock, so both fall back to `monotonic`.
    ///
    /// Measures CPU time this thread spent running its own code
    ///
    /// | Property                              | Value                                    |
    /// | ------------------------------------- | ---------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                    |
    /// | Reacts to NTP changes                 | ✅ No                                    |
    /// | Counts system suspension times        | ✅ No                                    |
    /// | Advances while thread is de-scheduled | Varies by platform                       |
    /// | Might appear to go backwards          | ✅ No                                    |
    /// | Reads a cached value                  | Varies by platform                       |
    /// | Max staleness                         | Varies by platform                       |
    /// | Warm read cost                        | Platform dependent; ~ 56-460ns @ 4GHz    |
    /// | Cold read cost                        | Platform dependent; ~ 425ns-5.8µs @ 4GHz |
    /// | Step granularity                      | Platform dependent; 42ns-15.6ms          |
    ///
    /// | Platform       | Clock                             |
    /// | -------------- | --------------------------------- |
    /// | Darwin         | ``DarwinClockID/threadUserTime``  |
    /// | Linux, Android | ``LinuxClockID/threadUserTime``   |
    /// | Windows        | ``WindowsClockID/threadUserTime`` |
    /// | FreeBSD        | ``FreeBSDClockID/threadUserTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/threadUserTime`` |
    /// | WASI           | ``WASIClockID/monotonic``         |
    /// | Fallback       | ``STDChronoClockID/monotonic``    |
    @inlinable
    public static var threadUserTime: GenericSystemClock {
        GenericSystemClock(
            darwin: .threadUserTime,
            linux: .threadUserTime,
            windows: .threadUserTime,
            freebsd: .threadUserTime,
            openbsd: .threadUserTime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }

    /// CPU time the kernel has used on the calling thread's behalf.
    ///
    /// Neither wasi-libc nor `<chrono>` has a cpu-time clock, so both fall back to `monotonic`.
    ///
    /// Measures CPU time the kernel spent on this thread's behalf
    ///
    /// | Property                              | Value                                    |
    /// | ------------------------------------- | ---------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                    |
    /// | Reacts to NTP changes                 | ✅ No                                    |
    /// | Counts system suspension times        | ✅ No                                    |
    /// | Advances while thread is de-scheduled | Varies by platform                       |
    /// | Might appear to go backwards          | ✅ No                                    |
    /// | Reads a cached value                  | Varies by platform                       |
    /// | Max staleness                         | Varies by platform                       |
    /// | Warm read cost                        | Platform dependent; ~ 56-460ns @ 4GHz    |
    /// | Cold read cost                        | Platform dependent; ~ 425ns-5.2µs @ 4GHz |
    /// | Step granularity                      | Platform dependent; 42ns-15.6ms          |
    ///
    /// | Platform       | Clock                               |
    /// | -------------- | ----------------------------------- |
    /// | Darwin         | ``DarwinClockID/threadSystemTime``  |
    /// | Linux, Android | ``LinuxClockID/threadSystemTime``   |
    /// | Windows        | ``WindowsClockID/threadKernelTime`` |
    /// | FreeBSD        | ``FreeBSDClockID/threadSystemTime`` |
    /// | OpenBSD        | ``OpenBSDClockID/threadSystemTime`` |
    /// | WASI           | ``WASIClockID/monotonic``           |
    /// | Fallback       | ``STDChronoClockID/monotonic``      |
    @inlinable
    public static var threadSystemTime: GenericSystemClock {
        GenericSystemClock(
            darwin: .threadSystemTime,
            linux: .threadSystemTime,
            windows: .threadKernelTime,
            freebsd: .threadSystemTime,
            openbsd: .threadSystemTime,
            wasi: .monotonic,
            fallback: .monotonic
        )
    }
}

#if !$Embedded
@available(SwiftStdlib 5.7, *)
extension Clock where Self == GenericSystemClock<CompactDuration> {
    /// See ``GenericSystemClock/realtime``.
    @inlinable
    public static var systemRealtime: GenericSystemClock<CompactDuration> {
        GenericSystemClock.realtime
    }

    /// See ``GenericSystemClock/realtimeCoarse``.
    @inlinable
    public static var systemRealtimeCoarse: GenericSystemClock<CompactDuration> {
        GenericSystemClock.realtimeCoarse
    }

    /// See ``GenericSystemClock/continuous``.
    @inlinable
    public static var systemContinuous: GenericSystemClock<CompactDuration> {
        GenericSystemClock.continuous
    }

    /// See ``GenericSystemClock/continuousCoarse``.
    @inlinable
    public static var systemContinuousCoarse: GenericSystemClock<CompactDuration> {
        GenericSystemClock.continuousCoarse
    }

    /// See ``GenericSystemClock/suspending``.
    @inlinable
    public static var systemSuspending: GenericSystemClock<CompactDuration> {
        GenericSystemClock.suspending
    }

    /// See ``GenericSystemClock/suspendingCoarse``.
    @inlinable
    public static var systemSuspendingCoarse: GenericSystemClock<CompactDuration> {
        GenericSystemClock.suspendingCoarse
    }

    /// See ``GenericSystemClock/processCPUTime``.
    @inlinable
    public static var systemProcessCPUTime: GenericSystemClock<CompactDuration> {
        GenericSystemClock.processCPUTime
    }

    /// See ``GenericSystemClock/threadCPUTime``.
    @inlinable
    public static var systemThreadCPUTime: GenericSystemClock<CompactDuration> {
        GenericSystemClock.threadCPUTime
    }

    /// See ``GenericSystemClock/processUserTime``.
    @inlinable
    public static var systemProcessUserTime: GenericSystemClock<CompactDuration> {
        GenericSystemClock.processUserTime
    }

    /// See ``GenericSystemClock/processSystemTime``.
    @inlinable
    public static var systemProcessSystemTime: GenericSystemClock<CompactDuration> {
        GenericSystemClock.processSystemTime
    }

    /// See ``GenericSystemClock/threadUserTime``.
    @inlinable
    public static var systemThreadUserTime: GenericSystemClock<CompactDuration> {
        GenericSystemClock.threadUserTime
    }

    /// See ``GenericSystemClock/threadSystemTime``.
    @inlinable
    public static var systemThreadSystemTime: GenericSystemClock<CompactDuration> {
        GenericSystemClock.threadSystemTime
    }
}
#endif
