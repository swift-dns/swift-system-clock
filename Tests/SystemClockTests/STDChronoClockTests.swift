import CSystemClock
import SystemClock
import Testing

/// No platform the tests run on reaches `<chrono>`, so it is exercised through `CSystemClock`.
@Suite
struct STDChronoClockTests {
    static func read(_ id: STDChronoClockID) -> (result: Int32, nanoseconds: Int64) {
        var nanoseconds: Int64 = -1
        let result = unsafe csystem_clock_std_chrono_gettime(id.rawValue, &nanoseconds)
        return (result, nanoseconds)
    }

    static func resolution(_ id: STDChronoClockID) -> (result: Int32, nanoseconds: Int64) {
        var nanoseconds: Int64 = -1
        let result = unsafe csystem_clock_std_chrono_getres(id.rawValue, &nanoseconds)
        return (result, nanoseconds)
    }

    @Test(arguments: [STDChronoClockID.monotonic, .realtime, .highResolution])
    func `every clock std::chrono names reads`(id: STDChronoClockID) {
        let reading = Self.read(id)
        #expect(reading.result == 0)
        #expect(reading.nanoseconds > 0)
    }

    @Test(arguments: [STDChronoClockID.monotonic, .realtime, .highResolution])
    func `every clock std::chrono names has a resolution of at least a nanosecond`(
        id: STDChronoClockID
    ) {
        let reading = Self.resolution(id)
        #expect(reading.result == 0)
        #expect(reading.nanoseconds >= 1)
    }

    @Test(arguments: [STDChronoClockID.monotonic, .realtime, .highResolution])
    func `every clock std::chrono names never goes backwards`(id: STDChronoClockID) {
        let first = Self.read(id)
        let second = Self.read(id)
        #expect(first.result == 0)
        #expect(second.result == 0)
        #expect(second.nanoseconds >= first.nanoseconds)
    }

    @Test func `the wall clock counts from the unix epoch`() {
        /// 2020-01-01 UTC, so that the reading is a date rather than an uptime.
        #expect(Self.read(.realtime).nanoseconds > 1_577_836_800_000_000_000)
    }

    @Test func `the steady clock does not count from the unix epoch`() {
        #expect(Self.read(.monotonic).nanoseconds < 1_577_836_800_000_000_000)
    }

    @Test(arguments: [STDChronoClockID.unavailable, STDChronoClockID(rawValue: 9_999)])
    func `an id std::chrono has no clock for is rejected`(id: STDChronoClockID) {
        #expect(Self.read(id).result == -1)
        #expect(Self.resolution(id).result == -1)
    }

    @Test func `an id std::chrono has no clock for leaves the reading untouched`() {
        var nanoseconds: Int64 = 77
        #expect(
            unsafe csystem_clock_std_chrono_gettime(
                STDChronoClockID.unavailable.rawValue,
                &nanoseconds
            ) == -1
        )
        #expect(nanoseconds == 77)
    }
}
