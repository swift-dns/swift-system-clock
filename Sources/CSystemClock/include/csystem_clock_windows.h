#ifndef CSYSTEM_CLOCK_WINDOWS_H
#define CSYSTEM_CLOCK_WINDOWS_H

#if defined(_WIN32)

#include <stdint.h>

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <realtimeapiset.h>
#pragma comment(lib, "mincore.lib")

#ifdef __cplusplus
extern "C" {
#endif

static inline int64_t csystem_clock_windows_query_performance_counter(void) {
    LARGE_INTEGER counter;
    if (!QueryPerformanceCounter(&counter)) {
        return -1;
    }
    return (int64_t)counter.QuadPart;
}

// Uncached: a local static would race, and Windows already serves this from a mapped page.
static inline int64_t csystem_clock_windows_query_performance_frequency(void) {
    LARGE_INTEGER frequency;
    if (!QueryPerformanceFrequency(&frequency)) {
        return 0;
    }
    return (int64_t)frequency.QuadPart;
}

static inline uint64_t csystem_clock_windows_query_interrupt_time(void) {
    ULONGLONG intervals = 0;
    QueryInterruptTime(&intervals);
    return (uint64_t)intervals;
}

static inline uint64_t csystem_clock_windows_query_interrupt_time_precise(void) {
    ULONGLONG intervals = 0;
    QueryInterruptTimePrecise(&intervals);
    return (uint64_t)intervals;
}

static inline int64_t csystem_clock_windows_query_unbiased_interrupt_time(void) {
    ULONGLONG intervals = 0;
    if (!QueryUnbiasedInterruptTime(&intervals)) {
        return -1;
    }
    return (int64_t)intervals;
}

static inline uint64_t csystem_clock_windows_query_unbiased_interrupt_time_precise(void) {
    ULONGLONG intervals = 0;
    QueryUnbiasedInterruptTimePrecise(&intervals);
    return (uint64_t)intervals;
}

#ifdef __cplusplus
}
#endif

#endif // _WIN32

#endif // CSYSTEM_CLOCK_WINDOWS_H
