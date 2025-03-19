// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Website",
  defaultLocalization: "en",
  platforms: [.macOS(.v14)],
  dependencies: [
    .package(url: "https://github.com/twostraws/Ignite", revision: "3080060aca91fe431b31d4a9b2bba2a99d81b25a"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.0"),
    .package(path: "../MyLibrary")
  ],
  targets: [
    .executableTarget(
      name: "Website",
      dependencies: [
        "Ignite",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DataClient", package: "MyLibrary"),
        .product(name: "ScheduleFeature", package: "MyLibrary"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
  ]
)
