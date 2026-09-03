import SystemClock
import Testing

@Suite
struct DefaultClocksTests {
    @Test(arguments: ShortcutClock.all)
    func `every shortcut names the clock it stands for`(shortcutClock: ShortcutClock) {
        #expect(
            shortcutClock.clockFromShortcutExtension.currentClockID
                == shortcutClock.clockFromDirectExtension.currentClockID
        )
    }

    @Test(arguments: ShortcutClock.all)
    func `every shortcut reads and reports a resolution`(shortcutClock: ShortcutClock) {
        _ = shortcutClock.clockFromShortcutExtension.now
        #expect(shortcutClock.clockFromShortcutExtension.minimumResolution > .zero)
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

struct ShortcutClock: Sendable, CustomStringConvertible {
    var name: String
    var clockFromShortcutExtension: SystemClock
    var clockFromDirectExtension: SystemClock

    init(name: String, shortcut: some Clock, direct: SystemClock) {
        self.name = name
        self.clockFromShortcutExtension = shortcut as! SystemClock
        self.clockFromDirectExtension = direct
    }

    var description: String {
        self.name
    }
}

extension ShortcutClock {
    static var all: [ShortcutClock] {
        [
            ShortcutClock(name: "realtime", shortcut: .systemRealtime, direct: .realtime),
            ShortcutClock(
                name: "realtimeCoarse",
                shortcut: .systemRealtimeCoarse,
                direct: .realtimeCoarse
            ),
            ShortcutClock(name: "continuous", shortcut: .systemContinuous, direct: .continuous),
            ShortcutClock(
                name: "continuousCoarse",
                shortcut: .systemContinuousCoarse,
                direct: .continuousCoarse
            ),
            ShortcutClock(name: "suspending", shortcut: .systemSuspending, direct: .suspending),
            ShortcutClock(
                name: "suspendingCoarse",
                shortcut: .systemSuspendingCoarse,
                direct: .suspendingCoarse
            ),
            ShortcutClock(
                name: "processCPUTime",
                shortcut: .systemProcessCPUTime,
                direct: .processCPUTime
            ),
            ShortcutClock(
                name: "threadCPUTime",
                shortcut: .systemThreadCPUTime,
                direct: .threadCPUTime
            ),
            ShortcutClock(
                name: "processUserTime",
                shortcut: .systemProcessUserTime,
                direct: .processUserTime
            ),
            ShortcutClock(
                name: "processSystemTime",
                shortcut: .systemProcessSystemTime,
                direct: .processSystemTime
            ),
            ShortcutClock(
                name: "threadUserTime",
                shortcut: .systemThreadUserTime,
                direct: .threadUserTime
            ),
            ShortcutClock(
                name: "threadSystemTime",
                shortcut: .systemThreadSystemTime,
                direct: .threadSystemTime
            ),
        ]
    }
}
