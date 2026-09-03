public import CSystemClock

/// A C++ `<chrono>` clock identifier.
///
/// `<chrono>` has no clock ids; each of its clocks is a C++ type, so `rawValue` is this library's
/// own identifier and is translated to a type before any call.
public struct STDChronoClockID: Sendable, Hashable, RawRepresentable {
    public let rawValue: Int32

    @inlinable
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

extension STDChronoClockID {
    /// The id for a clock `<chrono>` has none of.
    @inlinable
    public static var unavailable: STDChronoClockID {
        STDChronoClockID(rawValue: csystem_clock_std_chrono_unavailable)
    }

    /// `std::chrono::steady_clock`
    ///
    /// [cppreference](https://en.cppreference.com/w/cpp/chrono/steady_clock)
    ///
    /// Measures Elapsed time, from an arbitrary point
    ///
    /// | Property                              | Value                    |
    /// | ------------------------------------- | ------------------------ |
    /// | Reacts to OS time changes             | ✅ No                    |
    /// | Reacts to NTP changes                 | ✅ No                    |
    /// | Counts system suspension times        | Implementation-dependant |
    /// | Advances while thread is de-scheduled | ❌ Yes                   |
    /// | Might appear to go backwards          | ✅ No                    |
    /// | Reads a cached value                  | Implementation-dependant |
    /// | Max staleness                         | Implementation-dependant |
    /// | Warm read cost                        | Implementation-dependant |
    /// | Cold read cost                        | Implementation-dependant |
    /// | Step granularity                      | Implementation-dependant |
    @inlinable
    public static var monotonic: STDChronoClockID {
        STDChronoClockID(rawValue: csystem_clock_std_chrono_monotonic)
    }

    /// `std::chrono::system_clock`
    ///
    /// [cppreference](https://en.cppreference.com/w/cpp/chrono/system_clock)
    ///
    /// Measures Wall time, counted from 1970-01-01 UTC (guaranteed since C++20)
    ///
    /// | Property                              | Value                    |
    /// | ------------------------------------- | ------------------------ |
    /// | Reacts to OS time changes             | ❌ Yes                   |
    /// | Reacts to NTP changes                 | ❌ Yes                   |
    /// | Counts system suspension times        | ❌ Yes                   |
    /// | Advances while thread is de-scheduled | ❌ Yes                   |
    /// | Might appear to go backwards          | ❌ Yes                   |
    /// | Reads a cached value                  | Implementation-dependant |
    /// | Max staleness                         | Implementation-dependant |
    /// | Warm read cost                        | Implementation-dependant |
    /// | Cold read cost                        | Implementation-dependant |
    /// | Step granularity                      | Implementation-dependant |
    @inlinable
    public static var realtime: STDChronoClockID {
        STDChronoClockID(rawValue: csystem_clock_std_chrono_realtime)
    }

    /// `std::chrono::high_resolution_clock`
    ///
    /// [cppreference](https://en.cppreference.com/w/cpp/chrono/high_resolution_clock)
    ///
    /// Measurements dependant on the underlying implementation: ``monotonic`` on libc++ and
    /// Microsoft's STL, ``realtime`` on libstdc++
    ///
    /// | Property                              | Value                    |
    /// | ------------------------------------- | ------------------------ |
    /// | Reacts to OS time changes             | Implementation-dependant |
    /// | Reacts to NTP changes                 | Implementation-dependant |
    /// | Counts system suspension times        | Implementation-dependant |
    /// | Advances while thread is de-scheduled | ❌ Yes                   |
    /// | Might appear to go backwards          | Implementation-dependant |
    /// | Reads a cached value                  | Implementation-dependant |
    /// | Max staleness                         | Implementation-dependant |
    /// | Warm read cost                        | Implementation-dependant |
    /// | Cold read cost                        | Implementation-dependant |
    /// | Step granularity                      | Implementation-dependant |
    @inlinable
    public static var highResolution: STDChronoClockID {
        STDChronoClockID(rawValue: csystem_clock_std_chrono_high_resolution)
    }
}
