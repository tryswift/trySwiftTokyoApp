// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "MyLibrary",
  defaultLocalization: "en",
  platforms: [.iOS(.v17), .macOS(.v14), .watchOS(.v10), .tvOS(.v17), .visionOS(.v1)],
  products: [
    .library(
      name: "AppFeature",
      targets: ["AppFeature"]),
    .library(
      name: "GuidanceFeature",
      targets: ["GuidanceFeature"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.1"),
    .package(url: "https://github.com/zunda-pixel/LicenseProvider", from: "1.1.1"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "GuidanceFeature",
        "ScheduleFeature",
        "SponsorFeature",
        "trySwiftFeature",
      ]
    ),
    .target(
      name: "DataClient",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "GuidanceFeature",
      dependencies: [
        "MapKitClient",
        "Safari",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "MapKitClient",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "Safari",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "ScheduleFeature",
      dependencies: [
        "DataClient",
        "Safari",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(name: "SharedModels"),
    .target(
      name: "SponsorFeature",
      dependencies: [
        "DataClient",
        "Safari",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "trySwiftFeature",
      dependencies: [
        "DataClient",
        "Safari",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      plugins: [
        .plugin(name: "LicenseProviderPlugin", package: "LicenseProvider")
      ]
    ),
    .testTarget(
      name: "ScheduleFeatureTests",
      dependencies: [
        "ScheduleFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
  ]
)
