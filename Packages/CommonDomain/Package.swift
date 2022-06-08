// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonDomain",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CommonDomain",
            targets: ["CommonDomain"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CommonDomain",
            dependencies: []
        ),
        .testTarget(
            name: "CommonDomainTests",
            dependencies: ["CommonDomain"]
        )
    ]
)
