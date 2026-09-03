#if os(macOS) || os(Linux) || os(FreeBSD) || os(OpenBSD) || os(Windows)

import SystemClock
import Testing

@Suite
struct RejectedClockIDTests {
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

    @Test func `reading a clock the operating system rejects traps`() async {
        await #expect(processExitsWith: .failure) {
            _ = RejectedClockIDTests.rejected.now
        }
    }

    @Test func `asking a rejected clock for its resolution traps`() async {
        await #expect(processExitsWith: .failure) {
            _ = RejectedClockIDTests.rejected.minimumResolution
        }
    }
}

#endif
