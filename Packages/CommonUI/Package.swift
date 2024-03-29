// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonUI",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CommonUI",
            targets: ["CommonUI"]
        )
    ],
    dependencies: [
        .package(path: "CommonDomain"),
        .package(path: "CommonPresentation")
    ],
    targets: [
        .target(
            name: "CommonUI",
            dependencies: ["CommonDomain", "CommonPresentation"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CommonUITests",
            dependencies: ["CommonUI"]
        )
    ]
)
