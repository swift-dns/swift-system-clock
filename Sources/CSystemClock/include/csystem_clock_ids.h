#ifndef CSYSTEM_CLOCK_IDS_H
#define CSYSTEM_CLOCK_IDS_H

#include <stdint.h>

#if !defined(_WIN32) && __has_include(<time.h>)
#include <time.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

// The ids live here in a header file so they are visible to Swift and can be inlined in callers.

// MARK: - Darwin
// clock_gettime(3), available since macOS 10.12. From the `clockid_t` enum in the SDK's
// <time.h>.

#define CSYSTEM_CLOCK_DARWIN_REALTIME 0
#define CSYSTEM_CLOCK_DARWIN_MONOTONIC 6
#define CSYSTEM_CLOCK_DARWIN_MONOTONIC_RAW 4
#define CSYSTEM_CLOCK_DARWIN_MONOTONIC_RAW_APPROX 5
#define CSYSTEM_CLOCK_DARWIN_UPTIME_RAW 8
#define CSYSTEM_CLOCK_DARWIN_UPTIME_RAW_APPROX 9
#define CSYSTEM_CLOCK_DARWIN_PROCESS_CPU_TIME 12
#define CSYSTEM_CLOCK_DARWIN_THREAD_CPU_TIME 16

static const int32_t csystem_clock_darwin_realtime = CSYSTEM_CLOCK_DARWIN_REALTIME;
static const int32_t csystem_clock_darwin_monotonic = CSYSTEM_CLOCK_DARWIN_MONOTONIC;
static const int32_t csystem_clock_darwin_monotonic_raw = CSYSTEM_CLOCK_DARWIN_MONOTONIC_RAW;
static const int32_t csystem_clock_darwin_monotonic_raw_approx =
    CSYSTEM_CLOCK_DARWIN_MONOTONIC_RAW_APPROX;
static const int32_t csystem_clock_darwin_uptime_raw = CSYSTEM_CLOCK_DARWIN_UPTIME_RAW;
static const int32_t csystem_clock_darwin_uptime_raw_approx =
    CSYSTEM_CLOCK_DARWIN_UPTIME_RAW_APPROX;
static const int32_t csystem_clock_darwin_process_cpu_time =
    CSYSTEM_CLOCK_DARWIN_PROCESS_CPU_TIME;
static const int32_t csystem_clock_darwin_thread_cpu_time =
    CSYSTEM_CLOCK_DARWIN_THREAD_CPU_TIME;

// MARK: - Linux
// clock_gettime(2). From <linux/time.h>, which is kernel ABI, so the numbers are frozen; glibc,
// musl and Bionic all repeat them. Also covers Android.

#define CSYSTEM_CLOCK_LINUX_REALTIME 0
#define CSYSTEM_CLOCK_LINUX_MONOTONIC 1
#define CSYSTEM_CLOCK_LINUX_PROCESS_CPU_TIME 2
#define CSYSTEM_CLOCK_LINUX_THREAD_CPU_TIME 3
#define CSYSTEM_CLOCK_LINUX_MONOTONIC_RAW 4
#define CSYSTEM_CLOCK_LINUX_REALTIME_COARSE 5
#define CSYSTEM_CLOCK_LINUX_MONOTONIC_COARSE 6
#define CSYSTEM_CLOCK_LINUX_BOOTTIME 7
#define CSYSTEM_CLOCK_LINUX_REALTIME_ALARM 8
#define CSYSTEM_CLOCK_LINUX_BOOTTIME_ALARM 9
#define CSYSTEM_CLOCK_LINUX_TAI 11

static const int32_t csystem_clock_linux_realtime = CSYSTEM_CLOCK_LINUX_REALTIME;
static const int32_t csystem_clock_linux_monotonic = CSYSTEM_CLOCK_LINUX_MONOTONIC;
static const int32_t csystem_clock_linux_process_cpu_time =
    CSYSTEM_CLOCK_LINUX_PROCESS_CPU_TIME;
static const int32_t csystem_clock_linux_thread_cpu_time = CSYSTEM_CLOCK_LINUX_THREAD_CPU_TIME;
static const int32_t csystem_clock_linux_monotonic_raw = CSYSTEM_CLOCK_LINUX_MONOTONIC_RAW;
static const int32_t csystem_clock_linux_realtime_coarse = CSYSTEM_CLOCK_LINUX_REALTIME_COARSE;
static const int32_t csystem_clock_linux_monotonic_coarse =
    CSYSTEM_CLOCK_LINUX_MONOTONIC_COARSE;
static const int32_t csystem_clock_linux_boottime = CSYSTEM_CLOCK_LINUX_BOOTTIME;
static const int32_t csystem_clock_linux_realtime_alarm = CSYSTEM_CLOCK_LINUX_REALTIME_ALARM;
static const int32_t csystem_clock_linux_boottime_alarm = CSYSTEM_CLOCK_LINUX_BOOTTIME_ALARM;
static const int32_t csystem_clock_linux_tai = CSYSTEM_CLOCK_LINUX_TAI;

// MARK: - FreeBSD
// clock_gettime(2). From <sys/_clock_id.h>. `CLOCK_TAI` arrived in FreeBSD 15; on an older
// kernel the number is still the right one to ask for, and is rejected there.

#define CSYSTEM_CLOCK_FREEBSD_REALTIME 0
#define CSYSTEM_CLOCK_FREEBSD_VIRTUAL 1
#define CSYSTEM_CLOCK_FREEBSD_PROF 2
#define CSYSTEM_CLOCK_FREEBSD_MONOTONIC 4
#define CSYSTEM_CLOCK_FREEBSD_UPTIME 5
#define CSYSTEM_CLOCK_FREEBSD_UPTIME_PRECISE 7
#define CSYSTEM_CLOCK_FREEBSD_UPTIME_FAST 8
#define CSYSTEM_CLOCK_FREEBSD_REALTIME_PRECISE 9
#define CSYSTEM_CLOCK_FREEBSD_REALTIME_FAST 10
#define CSYSTEM_CLOCK_FREEBSD_MONOTONIC_PRECISE 11
#define CSYSTEM_CLOCK_FREEBSD_MONOTONIC_FAST 12
#define CSYSTEM_CLOCK_FREEBSD_SECOND 13
#define CSYSTEM_CLOCK_FREEBSD_THREAD_CPU_TIME 14
#define CSYSTEM_CLOCK_FREEBSD_PROCESS_CPU_TIME 15
#define CSYSTEM_CLOCK_FREEBSD_TAI 16

static const int32_t csystem_clock_freebsd_realtime = CSYSTEM_CLOCK_FREEBSD_REALTIME;
static const int32_t csystem_clock_freebsd_virtual = CSYSTEM_CLOCK_FREEBSD_VIRTUAL;
static const int32_t csystem_clock_freebsd_prof = CSYSTEM_CLOCK_FREEBSD_PROF;
static const int32_t csystem_clock_freebsd_monotonic = CSYSTEM_CLOCK_FREEBSD_MONOTONIC;
static const int32_t csystem_clock_freebsd_uptime = CSYSTEM_CLOCK_FREEBSD_UPTIME;
static const int32_t csystem_clock_freebsd_uptime_precise =
    CSYSTEM_CLOCK_FREEBSD_UPTIME_PRECISE;
static const int32_t csystem_clock_freebsd_uptime_fast = CSYSTEM_CLOCK_FREEBSD_UPTIME_FAST;
static const int32_t csystem_clock_freebsd_realtime_precise =
    CSYSTEM_CLOCK_FREEBSD_REALTIME_PRECISE;
static const int32_t csystem_clock_freebsd_realtime_fast = CSYSTEM_CLOCK_FREEBSD_REALTIME_FAST;
static const int32_t csystem_clock_freebsd_monotonic_precise =
    CSYSTEM_CLOCK_FREEBSD_MONOTONIC_PRECISE;
static const int32_t csystem_clock_freebsd_monotonic_fast =
    CSYSTEM_CLOCK_FREEBSD_MONOTONIC_FAST;
static const int32_t csystem_clock_freebsd_second = CSYSTEM_CLOCK_FREEBSD_SECOND;
static const int32_t csystem_clock_freebsd_thread_cpu_time =
    CSYSTEM_CLOCK_FREEBSD_THREAD_CPU_TIME;
static const int32_t csystem_clock_freebsd_process_cpu_time =
    CSYSTEM_CLOCK_FREEBSD_PROCESS_CPU_TIME;
static const int32_t csystem_clock_freebsd_tai = CSYSTEM_CLOCK_FREEBSD_TAI;

// The one id FreeBSD has renumbered. It aliased `CLOCK_UPTIME` until FreeBSD 15 moved it onto
// `CLOCK_MONOTONIC`, so it is the only id taken from the host's header rather than written
// down, and only stands at its FreeBSD 15 value off FreeBSD.
//
// https://github.com/freebsd/freebsd-src/commit/108de784513d
#define CSYSTEM_CLOCK_FREEBSD_BOOTTIME CSYSTEM_CLOCK_FREEBSD_MONOTONIC

#if defined(__FreeBSD__) && defined(CLOCK_BOOTTIME)
static const int32_t csystem_clock_freebsd_boottime = (int32_t)CLOCK_BOOTTIME;
#else
static const int32_t csystem_clock_freebsd_boottime = CSYSTEM_CLOCK_FREEBSD_BOOTTIME;
#endif

// MARK: - OpenBSD
// clock_gettime(2). From <sys/_time.h>.

#define CSYSTEM_CLOCK_OPENBSD_REALTIME 0
#define CSYSTEM_CLOCK_OPENBSD_PROCESS_CPU_TIME 2
#define CSYSTEM_CLOCK_OPENBSD_MONOTONIC 3
#define CSYSTEM_CLOCK_OPENBSD_THREAD_CPU_TIME 4
#define CSYSTEM_CLOCK_OPENBSD_UPTIME 5
#define CSYSTEM_CLOCK_OPENBSD_BOOTTIME 6

static const int32_t csystem_clock_openbsd_realtime = CSYSTEM_CLOCK_OPENBSD_REALTIME;
static const int32_t csystem_clock_openbsd_process_cpu_time =
    CSYSTEM_CLOCK_OPENBSD_PROCESS_CPU_TIME;
static const int32_t csystem_clock_openbsd_monotonic = CSYSTEM_CLOCK_OPENBSD_MONOTONIC;
static const int32_t csystem_clock_openbsd_thread_cpu_time =
    CSYSTEM_CLOCK_OPENBSD_THREAD_CPU_TIME;
static const int32_t csystem_clock_openbsd_uptime = CSYSTEM_CLOCK_OPENBSD_UPTIME;
static const int32_t csystem_clock_openbsd_boottime = CSYSTEM_CLOCK_OPENBSD_BOOTTIME;

// MARK: - Resource usage
// No platform has a clock id for one half of its cpu time; the halves come from `getrusage(2)`,
// or Mach's `thread_info` where `getrusage(2)` is not per-thread.

#define CSYSTEM_CLOCK_PROCESS_USER_CPU_TIME 1001
#define CSYSTEM_CLOCK_PROCESS_SYSTEM_CPU_TIME 1002
#define CSYSTEM_CLOCK_THREAD_USER_CPU_TIME 1003
#define CSYSTEM_CLOCK_THREAD_SYSTEM_CPU_TIME 1004

static const int32_t csystem_clock_process_user_cpu_time =
    CSYSTEM_CLOCK_PROCESS_USER_CPU_TIME;
static const int32_t csystem_clock_process_system_cpu_time =
    CSYSTEM_CLOCK_PROCESS_SYSTEM_CPU_TIME;
static const int32_t csystem_clock_thread_user_cpu_time = CSYSTEM_CLOCK_THREAD_USER_CPU_TIME;
static const int32_t csystem_clock_thread_system_cpu_time =
    CSYSTEM_CLOCK_THREAD_SYSTEM_CPU_TIME;

// MARK: - WASI
// wasi-libc's `clockid_t` is a pointer rather than a number, so these ids are this library's own
// identifiers, translated to wasi-libc's `CLOCK_*` below. wasi-libc declares only these two.

#define CSYSTEM_CLOCK_WASI_REALTIME 1
#define CSYSTEM_CLOCK_WASI_MONOTONIC 2

static const int32_t csystem_clock_wasi_realtime = CSYSTEM_CLOCK_WASI_REALTIME;
static const int32_t csystem_clock_wasi_monotonic = CSYSTEM_CLOCK_WASI_MONOTONIC;

#if defined(__wasi__)
static inline int csystem_clock_wasi_clockid(int32_t id, clockid_t *out) {
    if (id == csystem_clock_wasi_realtime) {
        *out = CLOCK_REALTIME;
        return 0;
    }
    if (id == csystem_clock_wasi_monotonic) {
        *out = CLOCK_MONOTONIC;
        return 0;
    }
    return -1;
}

static inline int csystem_clock_wasi_gettime(int32_t id, struct timespec *out) {
    clockid_t clock;
    if (csystem_clock_wasi_clockid(id, &clock) != 0) {
        return -1;
    }
    return clock_gettime(clock, out);
}

static inline int csystem_clock_wasi_getres(int32_t id, struct timespec *out) {
    clockid_t clock;
    if (csystem_clock_wasi_clockid(id, &clock) != 0) {
        return -1;
    }
    return clock_getres(clock, out);
}
#endif

// MARK: - Windows
// Windows has no `clockid_t`. These ids are this library's own identifiers.

#define CSYSTEM_CLOCK_WINDOWS_PERFORMANCE_COUNTER 1
#define CSYSTEM_CLOCK_WINDOWS_SYSTEM_TIME 2
#define CSYSTEM_CLOCK_WINDOWS_SYSTEM_TIME_PRECISE 3
#define CSYSTEM_CLOCK_WINDOWS_INTERRUPT_TIME 4
#define CSYSTEM_CLOCK_WINDOWS_INTERRUPT_TIME_PRECISE 5
#define CSYSTEM_CLOCK_WINDOWS_UNBIASED_INTERRUPT_TIME 6
#define CSYSTEM_CLOCK_WINDOWS_UNBIASED_INTERRUPT_TIME_PRECISE 7
#define CSYSTEM_CLOCK_WINDOWS_TICK_COUNT 8
#define CSYSTEM_CLOCK_WINDOWS_PROCESS_TIME 9
#define CSYSTEM_CLOCK_WINDOWS_THREAD_TIME 10

static const int32_t csystem_clock_windows_performance_counter =
    CSYSTEM_CLOCK_WINDOWS_PERFORMANCE_COUNTER;
static const int32_t csystem_clock_windows_system_time = CSYSTEM_CLOCK_WINDOWS_SYSTEM_TIME;
static const int32_t csystem_clock_windows_system_time_precise =
    CSYSTEM_CLOCK_WINDOWS_SYSTEM_TIME_PRECISE;
static const int32_t csystem_clock_windows_interrupt_time =
    CSYSTEM_CLOCK_WINDOWS_INTERRUPT_TIME;
static const int32_t csystem_clock_windows_interrupt_time_precise =
    CSYSTEM_CLOCK_WINDOWS_INTERRUPT_TIME_PRECISE;
static const int32_t csystem_clock_windows_unbiased_interrupt_time =
    CSYSTEM_CLOCK_WINDOWS_UNBIASED_INTERRUPT_TIME;
static const int32_t csystem_clock_windows_unbiased_interrupt_time_precise =
    CSYSTEM_CLOCK_WINDOWS_UNBIASED_INTERRUPT_TIME_PRECISE;
static const int32_t csystem_clock_windows_tick_count = CSYSTEM_CLOCK_WINDOWS_TICK_COUNT;
static const int32_t csystem_clock_windows_process_time = CSYSTEM_CLOCK_WINDOWS_PROCESS_TIME;
static const int32_t csystem_clock_windows_thread_time = CSYSTEM_CLOCK_WINDOWS_THREAD_TIME;

#ifdef __cplusplus
}
#endif

#endif // CSYSTEM_CLOCK_IDS_H
