/// An enum representing a specific platform's clock id.
@nonexhaustive
public enum AnySystemClockID: Sendable, Hashable {
    case darwin(DarwinClockID)
    case linux(LinuxClockID)
    case windows(WindowsClockID)
    case freebsd(FreeBSDClockID)
    case openbsd(OpenBSDClockID)
    case wasi(WASIClockID)
}
