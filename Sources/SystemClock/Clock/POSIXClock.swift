#if (os(Linux) || os(Android) || os(FreeBSD) || os(OpenBSD)) && !$Embedded

#if canImport(Glibc)
public import Glibc
#elseif canImport(Musl)
public import Musl
#elseif canImport(Android)
public import Android
#else
#error("The SystemClock module was unable to identify your C library.")
#endif

public import CSystemClock

@usableFromInline
struct POSIXClock: Sendable {
    @usableFromInline
    let id: clockid_t

    @inlinable
    init(id: Int32) {
        self.id = id
    }

    @inlinable
    @inline(always)
    func read() -> CompactDuration? {
        switch self.id {
        case csystem_clock_process_user_cpu_time:
            return POSIX.readResourceUsage(of: csystem_clock_rusage_self)?.user
        case csystem_clock_process_system_cpu_time:
            return POSIX.readResourceUsage(of: csystem_clock_rusage_self)?.system
        case csystem_clock_thread_user_cpu_time:
            return POSIX.readResourceUsage(of: csystem_clock_rusage_thread)?.user
        case csystem_clock_thread_system_cpu_time:
            return POSIX.readResourceUsage(of: csystem_clock_rusage_thread)?.system
        default:
            return self.readClockGettime()
        }
    }

    @inlinable
    @inline(always)
    func resolution() -> CompactDuration? {
        switch self.id {
        case csystem_clock_process_user_cpu_time, csystem_clock_process_system_cpu_time,
            csystem_clock_thread_user_cpu_time, csystem_clock_thread_system_cpu_time:
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
        var target = POSIX.clampedTimespec(from: deadline)
        let status = unsafe clock_nanosleep(self.id, TIMER_ABSTIME, &target, nil)
        if status != EINVAL && status != ENOTSUP && status != EOPNOTSUPP {
            return
        }
        POSIX.sleep(for: remaining)
    }

    @inlinable
    func readClockGettime() -> CompactDuration? {
        var value = timespec()
        guard unsafe clock_gettime(self.id, &value) == 0 else {
            return nil
        }
        return POSIX.duration(from: value)
    }
}

#endif
