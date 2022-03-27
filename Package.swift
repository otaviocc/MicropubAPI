// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MicropubAPI",
    platforms: [
        .macOS(.v12), .iOS(.v13)
    ],
    products: [
        .library(
            name: "MicropubAPI",
            targets: ["MicropubAPI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/otaviocc/MicroClient.git",
            from: "0.0.12"
        )
    ],
    targets: [
        .target(
            name: "MicropubAPI",
            dependencies: ["MicroClient"]
        ),
        .testTarget(
            name: "MicropubAPITests",
            dependencies: ["MicropubAPI"]
        )
    ]
)
