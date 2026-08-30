public import CSystemClock

/// A WASI clock identifier that can be passed to `clock_time_get`.
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
    /// Measures: Wall time, counted from 1970-01-01 UTC
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value         |
    /// | --------------------------------- | ------------- |
    /// | Affected by OS clock changes      | N/A           |
    /// | Affected by NTP changes           | N/A           |
    /// | Affected by system suspension     | N/A           |
    /// | Affected by process de-scheduling | ❌ Yes        |
    /// | Appears to go backwards           | N/A           |
    /// | Reads a cached value              | N/A           |
    /// | Possible staleness                | ✅ None       |
    /// | Typical read cost                 | ~ 57ns @ 4GHz |
    /// | Cold read cost                    | N/A           |
    /// | Step granularity                  | 1µs           |
    @inlinable
    public static var realtime: WASIClockID {
        WASIClockID(rawValue: csystem_clock_wasi_realtime)
    }

    /// `CLOCK_MONOTONIC`
    ///
    /// [WASI preview1](https://github.com/WebAssembly/WASI/blob/snapshot-01/phases/snapshot/docs.md)
    ///
    /// Measures: Elapsed time, from an arbitrary point
    ///
    /// The following values were measured under specific hardware and kernel versions.
    /// For better accuracy, measure under your own specific hardware and kernel.
    ///
    /// | Property                          | Value         |
    /// | --------------------------------- | ------------- |
    /// | Affected by OS clock changes      | ✅ No         |
    /// | Affected by NTP changes           | ✅ No         |
    /// | Affected by system suspension     | N/A           |
    /// | Affected by process de-scheduling | ❌ Yes        |
    /// | Appears to go backwards           | ✅ No         |
    /// | Reads a cached value              | N/A           |
    /// | Possible staleness                | ✅ None       |
    /// | Typical read cost                 | ~ 56ns @ 4GHz |
    /// | Cold read cost                    | N/A           |
    /// | Step granularity                  | 42ns          |
    @inlinable
    public static var monotonic: WASIClockID {
        WASIClockID(rawValue: csystem_clock_wasi_monotonic)
    }
}
