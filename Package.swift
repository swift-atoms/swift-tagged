// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-tagged",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Tagged",
            targets: ["Tagged"]
        ),
        .library(
            name: "Tagged Standard Library Integration",
            targets: ["Tagged Standard Library Integration"]
        ),
        .library(
            name: "Tagged Apple Foundation Integration",
            targets: ["Tagged Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Tagged",
            dependencies: []
        ),
        .target(
            name: "Tagged Standard Library Integration",
            dependencies: ["Tagged"]
        ),
        .target(
            name: "Tagged Apple Foundation Integration",
            dependencies: [
                "Tagged",
                "Tagged Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Tagged Tests",
            dependencies: ["Tagged"]
        ),
        .testTarget(
            name: "Tagged Standard Library Integration Tests",
            dependencies: [
                "Tagged",
                "Tagged Standard Library Integration",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .define(
            "SYNCHRONIZATION_AVAILABLE",
            .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])
        )
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
