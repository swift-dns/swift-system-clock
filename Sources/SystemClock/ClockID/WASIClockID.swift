public import CSystemClock

/// A WASI clock identifier.
///
/// wasi-libc's `clockid_t` is a pointer rather than a number, so `rawValue` is this library's own
/// identifier and is translated to wasi-libc's `CLOCK_*` before any call.
///
/// wasi-libc declares two clocks only, ``realtime`` and ``monotonic``.
/// The cpu-time clocks that WASI preview1 contained were dropped by WASI 0.2 and wasi-libc,
/// and are therefore unsupported by this library.
public struct WASIClockID: Sendable, Hashable, RawRepresentable {
    public let rawValue: Int32

    @inlinable
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

extension WASIClockID {
    /// `CLOCK_REALTIME`
    ///
    /// [WASI preview1](https://github.com/WebAssembly/WASI/blob/snapshot-01/phases/snapshot/docs.md)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC
    ///
    /// Whether it actually counts from 1970 (not e.g. boot time) is runtime-dependent.
    ///
    /// | Property                              | Value                                 |
    /// | ------------------------------------- | ------------------------------------- |
    /// | Reacts to OS time changes             | Runtime-dependent                     |
    /// | Reacts to NTP changes                 | Runtime-dependent                     |
    /// | Counts system suspension times        | Runtime-dependent                     |
    /// | Advances while thread is de-scheduled | ❌ Yes                                |
    /// | Might appear to go backwards          | Runtime-dependent                     |
    /// | Reads a cached value                  | Runtime-dependent                     |
    /// | Max staleness                         | ✅ None                               |
    /// | Warm read cost                        | ~ 29-282ns; ~ 57ns on wasmtime @ 4GHz |
    /// | Cold read cost                        | N/A                                   |
    /// | Step granularity                      | 1µs on wasmtime                       |
    @inlinable
    public static var realtime: WASIClockID {
        WASIClockID(rawValue: csystem_clock_wasi_realtime)
    }

    /// `CLOCK_MONOTONIC`
    ///
    /// [WASI preview1](https://github.com/WebAssembly/WASI/blob/snapshot-01/phases/snapshot/docs.md)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                                 |
    /// | ------------------------------------- | ------------------------------------- |
    /// | Reacts to OS time changes             | ✅ No                                 |
    /// | Reacts to NTP changes                 | Runtime-dependent                     |
    /// | Counts system suspension times        | Runtime-dependent                     |
    /// | Advances while thread is de-scheduled | ❌ Yes                                |
    /// | Might appear to go backwards          | ✅ No                                 |
    /// | Reads a cached value                  | Runtime-dependent                     |
    /// | Max staleness                         | ✅ None                               |
    /// | Warm read cost                        | ~ 25-284ns; ~ 56ns on wasmtime @ 4GHz |
    /// | Cold read cost                        | N/A                                   |
    /// | Step granularity                      | 42ns on wasmtime                      |
    @inlinable
    public static var monotonic: WASIClockID {
        WASIClockID(rawValue: csystem_clock_wasi_monotonic)
    }
}
