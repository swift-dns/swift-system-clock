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
            .processUserTime,
            .processSystemTime,
            .threadUserTime,
            .threadSystemTime,
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
            .processUserTime,
            .processSystemTime,
            .threadUserTime,
            .threadSystemTime,
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
            .processUserTime,
            .processSystemTime,
            .threadUserTime,
            .threadSystemTime,
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
            .processUserTime,
            .processSystemTime,
            .threadUserTime,
            .threadSystemTime,
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
            .processUserTime,
            .processKernelTime,
            .threadUserTime,
            .threadKernelTime,
        ]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `WASI ids are all distinct`() {
        let ids: [WASIClockID] = [.realtime, .monotonic]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `std::chrono ids are all distinct`() {
        let ids: [STDChronoClockID] = [.monotonic, .realtime, .highResolution]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `RawRepresentable round-trips`() {
        #expect(DarwinClockID(rawValue: DarwinClockID.uptimeRaw.rawValue) == .uptimeRaw)
        #expect(FreeBSDClockID(rawValue: FreeBSDClockID.uptime.rawValue) == .uptime)
        #expect(LinuxClockID(rawValue: LinuxClockID.boottime.rawValue) == .boottime)
        #expect(OpenBSDClockID(rawValue: OpenBSDClockID.realtime.rawValue) == .realtime)
        #expect(WindowsClockID(rawValue: WindowsClockID.tickCount.rawValue) == .tickCount)
        #expect(WASIClockID(rawValue: WASIClockID.monotonic.rawValue) == .monotonic)
        #expect(
            STDChronoClockID(rawValue: STDChronoClockID.highResolution.rawValue) == .highResolution
        )
    }

    @Test(arguments: ClockIDExpectation.all)
    func `every default clock reports the currentClockID it was built from`(
        expectation: ClockIDExpectation
    ) {
        #expect(expectation.clock.currentClockID == expectation.id)
    }

    @Test func `clocks built from different ids report different currentClockIDs`() {
        let ids = ClockIDExpectation.all.map(\.clock.currentClockID)
        let expected = ClockIDExpectation.all.map(\.id)
        #expect(Set(ids) == Set(expected))
    }

    /// WASI and Windows number their ids from one too, so only the case keeps them apart.
    @Test func `an std::chrono id never equals another platform's id of the same number`() {
        let ids: [AnySystemClockID] = [
            .stdChrono(.monotonic),
            .stdChrono(.realtime),
            .stdChrono(.highResolution),
            .wasi(.realtime),
            .wasi(.monotonic),
            .windows(.performanceCounter),
            .windows(.systemTime),
            .linux(.realtime),
            .linux(.monotonic),
            .darwin(.realtime),
        ]
        #expect(Set(ids).count == ids.count)
    }

    @Test func `an explicitly built clock reports the currentClockID it was given`() {
        let clock = GenericSystemClock<Swift.Duration>(
            darwin: .monotonic,
            linux: .monotonicRaw,
            windows: .tickCount,
            freebsd: .second,
            openbsd: .monotonic,
            wasi: .monotonic,
            fallback: .highResolution
        )
        #if canImport(Darwin)
        #expect(clock.currentClockID == .darwin(.monotonic))
        #elseif os(Linux) || os(Android)
        #expect(clock.currentClockID == .linux(.monotonicRaw))
        #elseif os(Windows)
        #expect(clock.currentClockID == .windows(.tickCount))
        #elseif os(FreeBSD)
        #expect(clock.currentClockID == .freebsd(.second))
        #elseif os(OpenBSD)
        #expect(clock.currentClockID == .openbsd(.monotonic))
        #elseif os(WASI)
        #expect(clock.currentClockID == .wasi(.monotonic))
        #else
        #expect(clock.currentClockID == .stdChrono(.highResolution))
        #endif
    }

    static var rejected: GenericSystemClock<Swift.Duration> {
        GenericSystemClock(
            darwin: DarwinClockID(rawValue: 9_999),
            linux: LinuxClockID(rawValue: 9_999),
            windows: WindowsClockID(rawValue: 9_999),
            freebsd: FreeBSDClockID(rawValue: 9_999),
            openbsd: OpenBSDClockID(rawValue: 9_999),
            wasi: WASIClockID(rawValue: 9_999),
            fallback: STDChronoClockID(rawValue: 9_999)
        )
    }

    @Test func `a rejected id is still the id the clock reports`() {
        #if canImport(Darwin)
        #expect(Self.rejected.currentClockID == .darwin(DarwinClockID(rawValue: 9_999)))
        #elseif os(Linux) || os(Android)
        #expect(Self.rejected.currentClockID == .linux(LinuxClockID(rawValue: 9_999)))
        #elseif os(Windows)
        #expect(Self.rejected.currentClockID == .windows(WindowsClockID(rawValue: 9_999)))
        #elseif os(FreeBSD)
        #expect(Self.rejected.currentClockID == .freebsd(FreeBSDClockID(rawValue: 9_999)))
        #elseif os(OpenBSD)
        #expect(Self.rejected.currentClockID == .openbsd(OpenBSDClockID(rawValue: 9_999)))
        #endif
    }

    #if os(macOS) || os(Linux) || os(FreeBSD) || os(OpenBSD) || os(Windows)
    @Test func `reading a clock the operating system rejects traps`() async {
        await #expect(processExitsWith: .failure) {
            _ = ClockIDTests.rejected.now
        }
    }

    @Test func `asking a rejected clock for its resolution traps`() async {
        await #expect(processExitsWith: .failure) {
            _ = ClockIDTests.rejected.minimumResolution
        }
    }
    #endif
}

/// A default clock paired with the platform id it is built from, so that ``currentClockID`` can
/// be checked against the table it is documented by.
struct ClockIDExpectation: Sendable, CustomStringConvertible {
    var name: String
    var clock: GenericSystemClock<Swift.Duration>
    var id: AnySystemClockID

    var description: String {
        self.name
    }
}

extension ClockIDExpectation {
    static var all: [ClockIDExpectation] {
        #if canImport(Darwin)
        let ids: [AnySystemClockID] = [
            .darwin(.realtime),
            .darwin(.realtime),
            .darwin(.monotonicRaw),
            .darwin(.monotonicRawApproximate),
            .darwin(.uptimeRaw),
            .darwin(.uptimeRawApproximate),
            .darwin(.processCPUTime),
            .darwin(.threadCPUTime),
        ]
        #elseif os(Linux) || os(Android)
        let ids: [AnySystemClockID] = [
            .linux(.realtime),
            .linux(.realtimeCoarse),
            .linux(.boottime),
            .linux(.boottime),
            .linux(.monotonic),
            .linux(.monotonicCoarse),
            .linux(.processCPUTime),
            .linux(.threadCPUTime),
        ]
        #elseif os(Windows)
        let ids: [AnySystemClockID] = [
            .windows(.systemTimePrecise),
            .windows(.systemTime),
            .windows(.interruptTimePrecise),
            .windows(.interruptTime),
            .windows(.unbiasedInterruptTimePrecise),
            .windows(.unbiasedInterruptTime),
            .windows(.processTime),
            .windows(.threadTime),
        ]
        #elseif os(FreeBSD)
        let ids: [AnySystemClockID] = [
            .freebsd(.realtimePrecise),
            .freebsd(.realtimeFast),
            .freebsd(.monotonic),
            .freebsd(.monotonicFast),
            .freebsd(.uptime),
            .freebsd(.uptimeFast),
            .freebsd(.processCPUTime),
            .freebsd(.threadCPUTime),
        ]
        #elseif os(OpenBSD)
        let ids: [AnySystemClockID] = [
            .openbsd(.realtime),
            .openbsd(.realtime),
            .openbsd(.boottime),
            .openbsd(.boottime),
            .openbsd(.uptime),
            .openbsd(.uptime),
            .openbsd(.processCPUTime),
            .openbsd(.threadCPUTime),
        ]
        #elseif os(WASI)
        let ids: [AnySystemClockID] = [
            .wasi(.realtime),
            .wasi(.realtime),
            .wasi(.monotonic),
            .wasi(.monotonic),
            .wasi(.monotonic),
            .wasi(.monotonic),
            .wasi(.monotonic),
            .wasi(.monotonic),
        ]
        #else
        let ids: [AnySystemClockID] = [
            .stdChrono(.realtime),
            .stdChrono(.realtime),
            .stdChrono(.monotonic),
            .stdChrono(.monotonic),
            .stdChrono(.monotonic),
            .stdChrono(.monotonic),
            .stdChrono(.monotonic),
            .stdChrono(.monotonic),
        ]
        #endif

        let clocks: [(String, GenericSystemClock<Swift.Duration>)] = [
            ("realtime", .realtime),
            ("realtimeCoarse", .realtimeCoarse),
            ("continuous", .continuous),
            ("continuousCoarse", .continuousCoarse),
            ("suspending", .suspending),
            ("suspendingCoarse", .suspendingCoarse),
            ("processCPUTime", .processCPUTime),
            ("threadCPUTime", .threadCPUTime),
        ]

        return zip(clocks, ids).map {
            ClockIDExpectation(name: $0.0.0, clock: $0.0.1, id: $0.1)
        }
    }
}
