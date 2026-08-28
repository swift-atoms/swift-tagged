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
            name: "Tagged Test Support",
            targets: ["Tagged Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-carrier.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Tagged",
            dependencies: [
                .product(name: "Carrier Protocol", package: "swift-carrier")
            ]
        ),
        .target(
            name: "Tagged Standard Library Integration",
            dependencies: [
                .target(name: "Tagged"),
                .product(
                    name: "Carrier Standard Library Integration",
                    package: "swift-carrier"
                ),
            ]
        ),
        .target(
            name: "Tagged Test Support",
            dependencies: [
                .target(name: "Tagged"),
                .target(name: "Tagged Standard Library Integration"),
                .product(
                    name: "Carrier Test Support",
                    package: "swift-carrier"
                ),
                .product(name: "Carrier Protocol", package: "swift-carrier"),
            ],
            path: "Tests/Tagged Test Support"
        ),
        .testTarget(
            name: "Tagged Tests",
            dependencies: [
                .target(name: "Tagged"),
                .target(name: "Tagged Standard Library Integration"),
                .target(name: "Tagged Test Support"),
                .product(name: "Carrier Protocol", package: "swift-carrier"),
                .product(
                    name: "Carrier Standard Library Integration",
                    package: "swift-carrier"
                ),
            ]
        ),
        .testTarget(
            name: "Tagged Standard Library Integration Tests",
            dependencies: [
                .target(name: "Tagged"),
                .target(name: "Tagged Standard Library Integration"),
                .target(name: "Tagged Test Support"),
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
