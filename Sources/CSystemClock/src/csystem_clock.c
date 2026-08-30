// The ids live in ../include/csystem_clock_ids.h so they fold into their callers. This file
// holds the checks that tie those ids back to the host's own headers, and gives the target a
// translation unit.
//
// An id is written down for every platform, not only the one being compiled for, so nothing
// here can check an id off its own platform. What it can do is fail the build the moment the
// host's headers stop agreeing with what this library says the host uses. Where an id is
// optional, the check is skipped rather than guessed: an id the host's headers do not declare
// is one the header comments explain is asked of the kernel regardless.
//
// WASI and Windows ids are this library's own and name nothing the operating system defines, so
// they have nothing to be checked against.

#include "../include/CSystemClock.h"

#if defined(__FreeBSD__)
#include <sys/param.h>
#endif

#if defined(__APPLE__)

_Static_assert(CLOCK_REALTIME == CSYSTEM_CLOCK_DARWIN_REALTIME, "CLOCK_REALTIME moved");
_Static_assert(CLOCK_MONOTONIC == CSYSTEM_CLOCK_DARWIN_MONOTONIC, "CLOCK_MONOTONIC moved");
_Static_assert(CLOCK_MONOTONIC_RAW == CSYSTEM_CLOCK_DARWIN_MONOTONIC_RAW,
               "CLOCK_MONOTONIC_RAW moved");
_Static_assert(CLOCK_MONOTONIC_RAW_APPROX == CSYSTEM_CLOCK_DARWIN_MONOTONIC_RAW_APPROX,
               "CLOCK_MONOTONIC_RAW_APPROX moved");
_Static_assert(CLOCK_UPTIME_RAW == CSYSTEM_CLOCK_DARWIN_UPTIME_RAW, "CLOCK_UPTIME_RAW moved");
_Static_assert(CLOCK_UPTIME_RAW_APPROX == CSYSTEM_CLOCK_DARWIN_UPTIME_RAW_APPROX,
               "CLOCK_UPTIME_RAW_APPROX moved");
_Static_assert(CLOCK_PROCESS_CPUTIME_ID == CSYSTEM_CLOCK_DARWIN_PROCESS_CPU_TIME,
               "CLOCK_PROCESS_CPUTIME_ID moved");
_Static_assert(CLOCK_THREAD_CPUTIME_ID == CSYSTEM_CLOCK_DARWIN_THREAD_CPU_TIME,
               "CLOCK_THREAD_CPUTIME_ID moved");

#elif defined(__linux__)

_Static_assert(CLOCK_REALTIME == CSYSTEM_CLOCK_LINUX_REALTIME, "CLOCK_REALTIME moved");
_Static_assert(CLOCK_MONOTONIC == CSYSTEM_CLOCK_LINUX_MONOTONIC, "CLOCK_MONOTONIC moved");
_Static_assert(CLOCK_PROCESS_CPUTIME_ID == CSYSTEM_CLOCK_LINUX_PROCESS_CPU_TIME,
               "CLOCK_PROCESS_CPUTIME_ID moved");
_Static_assert(CLOCK_THREAD_CPUTIME_ID == CSYSTEM_CLOCK_LINUX_THREAD_CPU_TIME,
               "CLOCK_THREAD_CPUTIME_ID moved");

#if defined(CLOCK_MONOTONIC_RAW)
_Static_assert(CLOCK_MONOTONIC_RAW == CSYSTEM_CLOCK_LINUX_MONOTONIC_RAW,
               "CLOCK_MONOTONIC_RAW moved");
#endif

#if defined(CLOCK_REALTIME_COARSE)
_Static_assert(CLOCK_REALTIME_COARSE == CSYSTEM_CLOCK_LINUX_REALTIME_COARSE,
               "CLOCK_REALTIME_COARSE moved");
#endif

#if defined(CLOCK_MONOTONIC_COARSE)
_Static_assert(CLOCK_MONOTONIC_COARSE == CSYSTEM_CLOCK_LINUX_MONOTONIC_COARSE,
               "CLOCK_MONOTONIC_COARSE moved");
#endif

#if defined(CLOCK_BOOTTIME)
_Static_assert(CLOCK_BOOTTIME == CSYSTEM_CLOCK_LINUX_BOOTTIME, "CLOCK_BOOTTIME moved");
#endif

#if defined(CLOCK_REALTIME_ALARM)
_Static_assert(CLOCK_REALTIME_ALARM == CSYSTEM_CLOCK_LINUX_REALTIME_ALARM,
               "CLOCK_REALTIME_ALARM moved");
#endif

#if defined(CLOCK_BOOTTIME_ALARM)
_Static_assert(CLOCK_BOOTTIME_ALARM == CSYSTEM_CLOCK_LINUX_BOOTTIME_ALARM,
               "CLOCK_BOOTTIME_ALARM moved");
#endif

#if defined(CLOCK_TAI)
_Static_assert(CLOCK_TAI == CSYSTEM_CLOCK_LINUX_TAI, "CLOCK_TAI moved");
#endif

#elif defined(__FreeBSD__)

_Static_assert(CLOCK_REALTIME == CSYSTEM_CLOCK_FREEBSD_REALTIME, "CLOCK_REALTIME moved");
_Static_assert(CLOCK_MONOTONIC == CSYSTEM_CLOCK_FREEBSD_MONOTONIC, "CLOCK_MONOTONIC moved");
_Static_assert(CLOCK_UPTIME_FAST == CSYSTEM_CLOCK_FREEBSD_UPTIME_FAST,
               "CLOCK_UPTIME_FAST moved");
_Static_assert(CLOCK_THREAD_CPUTIME_ID == CSYSTEM_CLOCK_FREEBSD_THREAD_CPU_TIME,
               "CLOCK_THREAD_CPUTIME_ID moved");
_Static_assert(CLOCK_PROCESS_CPUTIME_ID == CSYSTEM_CLOCK_FREEBSD_PROCESS_CPU_TIME,
               "CLOCK_PROCESS_CPUTIME_ID moved");

// The rest are FreeBSD's own, declared only when <sys/cdefs.h> makes them visible.

#if defined(CLOCK_VIRTUAL)
_Static_assert(CLOCK_VIRTUAL == CSYSTEM_CLOCK_FREEBSD_VIRTUAL, "CLOCK_VIRTUAL moved");
#endif

#if defined(CLOCK_PROF)
_Static_assert(CLOCK_PROF == CSYSTEM_CLOCK_FREEBSD_PROF, "CLOCK_PROF moved");
#endif

#if defined(CLOCK_UPTIME)
_Static_assert(CLOCK_UPTIME == CSYSTEM_CLOCK_FREEBSD_UPTIME, "CLOCK_UPTIME moved");
#endif

#if defined(CLOCK_UPTIME_PRECISE)
_Static_assert(CLOCK_UPTIME_PRECISE == CSYSTEM_CLOCK_FREEBSD_UPTIME_PRECISE,
               "CLOCK_UPTIME_PRECISE moved");
#endif

#if defined(CLOCK_REALTIME_PRECISE)
_Static_assert(CLOCK_REALTIME_PRECISE == CSYSTEM_CLOCK_FREEBSD_REALTIME_PRECISE,
               "CLOCK_REALTIME_PRECISE moved");
#endif

#if defined(CLOCK_REALTIME_FAST)
_Static_assert(CLOCK_REALTIME_FAST == CSYSTEM_CLOCK_FREEBSD_REALTIME_FAST,
               "CLOCK_REALTIME_FAST moved");
#endif

#if defined(CLOCK_MONOTONIC_PRECISE)
_Static_assert(CLOCK_MONOTONIC_PRECISE == CSYSTEM_CLOCK_FREEBSD_MONOTONIC_PRECISE,
               "CLOCK_MONOTONIC_PRECISE moved");
#endif

#if defined(CLOCK_MONOTONIC_FAST)
_Static_assert(CLOCK_MONOTONIC_FAST == CSYSTEM_CLOCK_FREEBSD_MONOTONIC_FAST,
               "CLOCK_MONOTONIC_FAST moved");
#endif

#if defined(CLOCK_SECOND)
_Static_assert(CLOCK_SECOND == CSYSTEM_CLOCK_FREEBSD_SECOND, "CLOCK_SECOND moved");
#endif

#if defined(CLOCK_TAI)
_Static_assert(CLOCK_TAI == CSYSTEM_CLOCK_FREEBSD_TAI, "CLOCK_TAI moved");
#endif

// FreeBSD 15 moved `CLOCK_BOOTTIME` off `CLOCK_UPTIME` and onto `CLOCK_MONOTONIC`, so which
// answer is right depends on the release being built against.
#if defined(CLOCK_BOOTTIME)
#if __FreeBSD_version >= 1500019
_Static_assert(CLOCK_BOOTTIME == CSYSTEM_CLOCK_FREEBSD_MONOTONIC,
               "CLOCK_BOOTTIME is no longer CLOCK_MONOTONIC");
#else
_Static_assert(CLOCK_BOOTTIME == CSYSTEM_CLOCK_FREEBSD_UPTIME,
               "CLOCK_BOOTTIME is no longer CLOCK_UPTIME");
#endif
#endif

#elif defined(__OpenBSD__)

_Static_assert(CLOCK_REALTIME == CSYSTEM_CLOCK_OPENBSD_REALTIME, "CLOCK_REALTIME moved");
_Static_assert(CLOCK_PROCESS_CPUTIME_ID == CSYSTEM_CLOCK_OPENBSD_PROCESS_CPU_TIME,
               "CLOCK_PROCESS_CPUTIME_ID moved");
_Static_assert(CLOCK_MONOTONIC == CSYSTEM_CLOCK_OPENBSD_MONOTONIC, "CLOCK_MONOTONIC moved");
_Static_assert(CLOCK_THREAD_CPUTIME_ID == CSYSTEM_CLOCK_OPENBSD_THREAD_CPU_TIME,
               "CLOCK_THREAD_CPUTIME_ID moved");

#if defined(CLOCK_UPTIME)
_Static_assert(CLOCK_UPTIME == CSYSTEM_CLOCK_OPENBSD_UPTIME, "CLOCK_UPTIME moved");
#endif

#if defined(CLOCK_BOOTTIME)
_Static_assert(CLOCK_BOOTTIME == CSYSTEM_CLOCK_OPENBSD_BOOTTIME, "CLOCK_BOOTTIME moved");
#endif

#endif
