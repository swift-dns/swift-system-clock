#if canImport(Darwin) && !$Embedded

public import Darwin
public import CSystemClock

@usableFromInline
struct DarwinClock: Sendable {
    @usableFromInline
    let id: clockid_t

    @inlinable
    var swiftyID: Int32 {
        Int32(bitPattern: self.id.rawValue)
    }

    @inlinable
    init(id: DarwinClockID) {
        self.id = clockid_t(rawValue: UInt32(bitPattern: id.rawValue))
    }

    @inlinable
    @inline(always)
    func read() -> CompactDuration? {
        switch self.swiftyID {
        case csystem_clock_process_user_cpu_time:
            return POSIX.readResourceUsage(of: csystem_clock_rusage_self)?.user
        case csystem_clock_process_system_cpu_time:
            return POSIX.readResourceUsage(of: csystem_clock_rusage_self)?.system
        case csystem_clock_thread_user_cpu_time:
            return Self.readThreadBasicInfo()?.user
        case csystem_clock_thread_system_cpu_time:
            return Self.readThreadBasicInfo()?.system
        default:
            return self.readClockGettime()
        }
    }

    @inlinable
    @inline(always)
    func resolution() -> CompactDuration? {
        switch self.swiftyID {
        case csystem_clock_process_user_cpu_time, csystem_clock_process_system_cpu_time,
            csystem_clock_thread_user_cpu_time, csystem_clock_thread_system_cpu_time:
            /// A `timeval` and a `time_value_t` both carry whole microseconds.
            return CompactDuration(nanoseconds: 1_000)
        default:
            var value = timespec()
            guard unsafe clock_getres(self.id, &value) == 0 else {
                return nil
            }
            return POSIX.duration(from: value)
        }
    }

    @inlinable
    @inline(always)
    func sleep(until deadline: CompactDuration, orFor remaining: CompactDuration) {
        POSIX.sleep(for: remaining)
    }

    @inlinable
    func readClockGettime() -> CompactDuration? {
        let nanoseconds = clock_gettime_nsec_np(self.id)
        if nanoseconds == 0 {
            return nil
        }
        return CompactDuration(nanoseconds: Int64(nanoseconds))
    }

    @inlinable
    static func readThreadBasicInfo() -> (user: CompactDuration, system: CompactDuration)? {
        var info = thread_basic_info()
        var count = mach_msg_type_number_t(
            MemoryLayout<thread_basic_info_data_t>.size / MemoryLayout<natural_t>.size
        )
        let status = withUnsafeMutablePointer(to: &info) {
            unsafe $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                unsafe thread_info(
                    pthread_mach_thread_np(pthread_self()),
                    thread_flavor_t(THREAD_BASIC_INFO),
                    $0,
                    &count
                )
            }
        }
        guard status == KERN_SUCCESS else {
            return nil
        }
        return (Self.duration(from: info.user_time), Self.duration(from: info.system_time))
    }

    /// A `thread_info(2)` reading, which Mach normalises to a remainder in `0..<1000000`.
    @inlinable
    static func duration(from value: time_value_t) -> CompactDuration {
        let seconds = Int64(value.seconds) * 1_000_000_000
        let microseconds = Int64(value.microseconds) * 1_000
        return CompactDuration(nanoseconds: seconds + microseconds)
    }
}

#endif
