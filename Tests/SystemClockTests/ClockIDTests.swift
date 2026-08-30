import SystemClock
import Testing

@Suite
struct ClockIDTests {
    @Test func `Darwin ids are all distinct`() {
        let ids: [DarwinClockID] = [
            .realtime,
            .monotonic,
            .monotonicRaw,
            .monotonicRawApproximate,
            .uptimeRaw,
            .uptimeRawApproximate,
            .processCPUTime,
            .threadCPUTime,
        ]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `Linux ids are all distinct`() {
        let ids: [LinuxClockID] = [
            .realtime,
            .realtimeAlarm,
            .realtimeCoarse,
            .tai,
            .monotonic,
            .monotonicCoarse,
            .monotonicRaw,
            .boottime,
            .boottimeAlarm,
            .processCPUTime,
            .threadCPUTime,
        ]
        #expect(Set(ids).count == ids.count)
    }

    /// FreeBSD 15 defines `CLOCK_BOOTTIME` as an alias of `CLOCK_MONOTONIC`, and every release
    /// before it as an alias of `CLOCK_UPTIME`.
    @Test func `FreeBSD ids are distinct apart from the boottime alias`() {
        let ids: [FreeBSDClockID] = [
            .realtime,
            .realtimePrecise,
            .realtimeFast,
            .monotonic,
            .monotonicPrecise,
            .monotonicFast,
            .uptime,
            .uptimePrecise,
            .uptimeFast,
            .tai,
            .virtual,
            .prof,
            .second,
            .processCPUTime,
            .threadCPUTime,
        ]
        #expect(Set(ids).count == ids.count)
        #if os(FreeBSD)
        #expect(FreeBSDClockID.boottime == .monotonic || FreeBSDClockID.boottime == .uptime)
        #else
        #expect(FreeBSDClockID.boottime == .monotonic)
        #endif
    }

    @Test func `OpenBSD ids are all distinct`() {
        let ids: [OpenBSDClockID] = [
            .realtime,
            .monotonic,
            .boottime,
            .uptime,
            .processCPUTime,
            .threadCPUTime,
        ]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `Windows ids are all distinct`() {
        let ids: [WindowsClockID] = [
            .performanceCounter,
            .systemTime,
            .systemTimePrecise,
            .interruptTime,
            .interruptTimePrecise,
            .unbiasedInterruptTime,
            .unbiasedInterruptTimePrecise,
            .tickCount,
            .processTime,
            .threadTime,
        ]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `WASI ids are all distinct`() {
        let ids: [WASIClockID] = [.realtime, .monotonic]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `RawRepresentable round-trips`() {
        #expect(DarwinClockID(rawValue: DarwinClockID.uptimeRaw.rawValue) == .uptimeRaw)
        #expect(LinuxClockID(rawValue: LinuxClockID.boottime.rawValue) == .boottime)
        #expect(WindowsClockID(rawValue: WindowsClockID.tickCount.rawValue) == .tickCount)
        #expect(WASIClockID(rawValue: WASIClockID.monotonic.rawValue) == .monotonic)
    }
}
