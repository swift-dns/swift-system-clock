#ifndef CSYSTEM_CLOCK_STD_CHRONO_H
#define CSYSTEM_CLOCK_STD_CHRONO_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// `<chrono>` has no clock ids; each of its clocks is a C++ type. These ids are this library's own
// identifiers, translated to a type in `csystem_clock_std_chrono.cpp`.

#define CSYSTEM_CLOCK_STD_CHRONO_MONOTONIC 1
#define CSYSTEM_CLOCK_STD_CHRONO_REALTIME 2
#define CSYSTEM_CLOCK_STD_CHRONO_HIGH_RESOLUTION 3

static const int32_t csystem_clock_std_chrono_monotonic = CSYSTEM_CLOCK_STD_CHRONO_MONOTONIC;
static const int32_t csystem_clock_std_chrono_realtime = CSYSTEM_CLOCK_STD_CHRONO_REALTIME;
static const int32_t csystem_clock_std_chrono_high_resolution =
    CSYSTEM_CLOCK_STD_CHRONO_HIGH_RESOLUTION;

// Both answer -1, leaving `*nanoseconds` untouched, for an id `<chrono>` has no clock for.

int csystem_clock_std_chrono_gettime(int32_t id, int64_t *nanoseconds);
int csystem_clock_std_chrono_getres(int32_t id, int64_t *nanoseconds);

#ifdef __cplusplus
}
#endif

#endif // CSYSTEM_CLOCK_STD_CHRONO_H
