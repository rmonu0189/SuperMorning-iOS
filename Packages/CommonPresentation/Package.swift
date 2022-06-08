// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonPresentation",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CommonPresentation",
            targets: ["CommonPresentation"]
        )
    ],
    dependencies: [
        .package(path: "CommonDomain")
    ],
    targets: [
        .target(
            name: "CommonPresentation",
            dependencies: ["CommonDomain"]
        ),
        .testTarget(
            name: "CommonPresentationTests",
            dependencies: ["CommonPresentation"]
        )
    ]
)
