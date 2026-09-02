import SystemClock
import Testing

struct ShortcutClock: Sendable, CustomStringConvertible {
    var name: String
    var shortcut: SystemClock
    var twin: SystemClock

    var description: String {
        self.name
    }
}

extension ShortcutClock {
    static var all: [ShortcutClock] {
        [
            ShortcutClock(name: "realtime", shortcut: .systemRealtime, twin: .realtime),
            ShortcutClock(
                name: "realtimeCoarse",
                shortcut: .systemRealtimeCoarse,
                twin: .realtimeCoarse
            ),
            ShortcutClock(name: "continuous", shortcut: .systemContinuous, twin: .continuous),
            ShortcutClock(
                name: "continuousCoarse",
                shortcut: .systemContinuousCoarse,
                twin: .continuousCoarse
            ),
            ShortcutClock(name: "suspending", shortcut: .systemSuspending, twin: .suspending),
            ShortcutClock(
                name: "suspendingCoarse",
                shortcut: .systemSuspendingCoarse,
                twin: .suspendingCoarse
            ),
            ShortcutClock(
                name: "processCPUTime",
                shortcut: .systemProcessCPUTime,
                twin: .processCPUTime
            ),
            ShortcutClock(
                name: "threadCPUTime",
                shortcut: .systemThreadCPUTime,
                twin: .threadCPUTime
            ),
            ShortcutClock(
                name: "processUserTime",
                shortcut: .systemProcessUserTime,
                twin: .processUserTime
            ),
            ShortcutClock(
                name: "processSystemTime",
                shortcut: .systemProcessSystemTime,
                twin: .processSystemTime
            ),
            ShortcutClock(
                name: "threadUserTime",
                shortcut: .systemThreadUserTime,
                twin: .threadUserTime
            ),
            ShortcutClock(
                name: "threadSystemTime",
                shortcut: .systemThreadSystemTime,
                twin: .threadSystemTime
            ),
        ]
    }
}

@Suite
struct DefaultClocksTests {
    @Test(arguments: ShortcutClock.all)
    func `every shortcut names the clock it stands for`(shortcutClock: ShortcutClock) {
        #expect(shortcutClock.shortcut.currentClockID == shortcutClock.twin.currentClockID)
    }

    @Test(arguments: ShortcutClock.all)
    func `every shortcut reads and reports a resolution`(shortcutClock: ShortcutClock) {
        _ = shortcutClock.shortcut.now
        #expect(shortcutClock.shortcut.minimumResolution > .zero)
    }

    @Test func `a system clock drives the standard library clock protocol`() async throws {
        let clock: SystemClock = .systemContinuous

        var accumulator: UInt64 = 0
        let measured = clock.measure {
            for index in UInt64(0)..<10_000 {
                accumulator = accumulator &+ index &* 2_654_435_761
            }
        }
        #expect(accumulator != 0)
        #expect(measured >= .zero)

        let start = clock.now
        try await Task.sleep(for: .milliseconds(20))
        #expect(start.duration(to: clock.now) >= .milliseconds(20))
    }

    @Test func `a compact clock and a Duration clock read the same instant`() {
        let compact = SystemClock.continuous
        let wide = GenericSystemClock<Swift.Duration>.continuous
        #expect(compact.currentClockID == wide.currentClockID)

        let compactReading = SystemClock.Instant.epoch.duration(to: compact.now)
        let wideReading = GenericSystemClock<Swift.Duration>.Instant.epoch.duration(to: wide.now)
        #expect(isClose(.nanoseconds(compactReading.nanoseconds), wideReading))
    }
}
