// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "swift-system-clock",
    products: [
        .library(name: "SystemClock", targets: ["SystemClock"])
    ],
    targets: [
        .target(
            name: "SystemClock",
            dependencies: ["CSystemClock"],
            swiftSettings: settings
        ),
        .target(
            name: "CSystemClock",
            linkerSettings: [
                /// `QueryInterruptTime` and friends live here.
                .linkedLibrary("mincore", .when(platforms: [.windows]))
            ]
        ),
        .testTarget(
            name: "SystemClockTests",
            dependencies: ["SystemClock"],
            swiftSettings: settings
        ),
    ]
)

var settings: [SwiftSetting] {
    [
        .swiftLanguageMode(.v6),
        .strictMemorySafety(),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("ExistentialAny"),
        .enableExperimentalFeature(
            "AvailabilityMacro=SwiftStdlib 5.1:macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0"
        ),
        .enableExperimentalFeature(
            "AvailabilityMacro=SwiftStdlib 5.7:macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0"
        ),
        .enableExperimentalFeature(
            "AvailabilityMacro=SwiftStdlib 6.0:macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0"
        ),
        .enableExperimentalFeature(
            "AvailabilityMacro=SwiftStdlib 6.2:macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0"
        ),
        .treatAllWarnings(as: .error),
        .treatWarning("StrictMemorySafety", as: .warning),
    ]
}
