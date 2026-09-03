#include "../include/csystem_clock_std_chrono.h"

// The test stdlib/public/Concurrency/Clock.cpp uses for the same fallback.
#if __has_include(<chrono>) && __STDC_HOSTED__

#include <chrono>

namespace {

template <typename Clock>
int64_t csystem_clock_std_chrono_read(void) {
    return (int64_t)std::chrono::duration_cast<std::chrono::nanoseconds>(
               Clock::now().time_since_epoch())
        .count();
}

// `period` is the clock's tick as a ratio of a second, truncated to whole nanoseconds and never
// reported below one.
template <typename Clock>
int64_t csystem_clock_std_chrono_resolution(void) {
    const int64_t nanoseconds =
        (int64_t)Clock::period::num * 1000000000 / (int64_t)Clock::period::den;
    return nanoseconds > 0 ? nanoseconds : 1;
}

}  // namespace

extern "C" int csystem_clock_std_chrono_gettime(int32_t id, int64_t *nanoseconds) {
    switch (id) {
    case CSYSTEM_CLOCK_STD_CHRONO_MONOTONIC:
        *nanoseconds = csystem_clock_std_chrono_read<std::chrono::steady_clock>();
        return 0;
    case CSYSTEM_CLOCK_STD_CHRONO_REALTIME:
        *nanoseconds = csystem_clock_std_chrono_read<std::chrono::system_clock>();
        return 0;
    case CSYSTEM_CLOCK_STD_CHRONO_HIGH_RESOLUTION:
        *nanoseconds = csystem_clock_std_chrono_read<std::chrono::high_resolution_clock>();
        return 0;
    default:
        return -1;
    }
}

extern "C" int csystem_clock_std_chrono_getres(int32_t id, int64_t *nanoseconds) {
    switch (id) {
    case CSYSTEM_CLOCK_STD_CHRONO_MONOTONIC:
        *nanoseconds = csystem_clock_std_chrono_resolution<std::chrono::steady_clock>();
        return 0;
    case CSYSTEM_CLOCK_STD_CHRONO_REALTIME:
        *nanoseconds = csystem_clock_std_chrono_resolution<std::chrono::system_clock>();
        return 0;
    case CSYSTEM_CLOCK_STD_CHRONO_HIGH_RESOLUTION:
        *nanoseconds =
            csystem_clock_std_chrono_resolution<std::chrono::high_resolution_clock>();
        return 0;
    default:
        return -1;
    }
}

// Only fatal where `<chrono>` is the only clock left; `<time.h>` keeps freestanding targets out.
#elif __has_include(<time.h>) && !defined(__APPLE__) && !defined(__linux__) \
    && !defined(_WIN32) && !defined(__wasi__) && !defined(__FreeBSD__) && !defined(__OpenBSD__)

#error "The SystemClock module does not know which clock ids your platform uses, and your C++ standard library has no <chrono> to fall back on."

#else

// Never reached from Swift; defined so a platform with its own clock ids links without `<chrono>`.

extern "C" int csystem_clock_std_chrono_gettime(int32_t id, int64_t *nanoseconds) {
    (void)id;
    (void)nanoseconds;
    return -1;
}

extern "C" int csystem_clock_std_chrono_getres(int32_t id, int64_t *nanoseconds) {
    (void)id;
    (void)nanoseconds;
    return -1;
}

#endif
