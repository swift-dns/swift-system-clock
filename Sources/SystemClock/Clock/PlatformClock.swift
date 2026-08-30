// ``SystemClock`` reaches the operating system through this and nothing else. Every platform
// clock is expected to provide, with no protocol saying so:
//
//     init(id: <the platform's clock id type>)
//     var rawID: Int32 { get }
//     func read() -> Duration?
//     func resolution() -> Duration?
//     func sleep(until deadline: Duration, orFor remaining: Duration)
//
// `read` and `resolution` answer `nil` when the operating system refuses the id. `sleep` takes
// both the deadline and the wait left over from it, because a platform that can wait on the
// clock itself wants the first and one that cannot wants the second.

#if canImport(Darwin)
@usableFromInline
typealias PlatformClock = DarwinClock
#elseif os(Linux) || os(Android) || os(FreeBSD) || os(OpenBSD)
@usableFromInline
typealias PlatformClock = POSIXClock
#elseif os(Windows)
@usableFromInline
typealias PlatformClock = WindowsClock
#elseif os(WASI)
@usableFromInline
typealias PlatformClock = WASIClock
#else
#error("The SystemClock module does not know which clock ids your platform uses.")
#endif
