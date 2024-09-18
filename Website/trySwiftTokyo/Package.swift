// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "trySwiftTokyo",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/twostraws/Ignite", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "trySwiftTokyo",
            dependencies: ["Ignite"]
        ),
    ]
)
