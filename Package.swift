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
        .library(name: "Tagged", targets: ["Tagged"]),

        .library(name: "Tagged Foundation Integration", targets: ["Tagged Foundation Integration"]),
        .library(name: "Tagged Test Support", targets: ["Tagged Test Support"]),
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
                .product(name: "Carrier", package: "swift-carrier"),
            ],
            path: "Sources/Tagged"
        ),
        
        .target(
            name: "Tagged Foundation Integration",
            dependencies: [
                .target(name: "Tagged"),
            ],
            path: "Sources/Tagged Foundation Integration"
        ),
        .target(
            name: "Tagged Test Support",
            dependencies: [
                .target(name: "Tagged"),
                .product(name: "Carrier Test Support", package: "swift-carrier"),
                .product(name: "Carrier", package: "swift-carrier"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Tagged Tests",
            dependencies: [
                .target(name: "Tagged"),
                .target(name: "Tagged Test Support"),
                .product(name: "Carrier", package: "swift-carrier"),
                .target(name: "Tagged Foundation Integration"),
            ],
            path: "Tests/Tagged Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .define("SYNCHRONIZATION_AVAILABLE", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])),
    ]
}
