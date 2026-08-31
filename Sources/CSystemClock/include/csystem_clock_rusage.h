#ifndef CSYSTEM_CLOCK_RUSAGE_H
#define CSYSTEM_CLOCK_RUSAGE_H

#if !defined(_WIN32) && !defined(__wasi__)

#include <stdint.h>
#include <sys/resource.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CSYSTEM_CLOCK_RUSAGE_SELF 0
#define CSYSTEM_CLOCK_RUSAGE_THREAD 1

static const int32_t csystem_clock_rusage_self = CSYSTEM_CLOCK_RUSAGE_SELF;
static const int32_t csystem_clock_rusage_thread = CSYSTEM_CLOCK_RUSAGE_THREAD;

static inline int csystem_clock_getrusage(int32_t who, struct rusage *usage) {
    return getrusage(who, usage);
}

#ifdef __cplusplus
}
#endif

#endif // !_WIN32 && !__wasi__

#endif // CSYSTEM_CLOCK_RUSAGE_H
