// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ChangeLogger",
  products: [
    .executable(name: "changelogger", targets: ["ChangeLogger"]),
    .library(name: "ChangeLoggerCLI", targets: ["ChangeLoggerCLI"]),
    .library(name: "ChangeLoggerKit", targets: ["ChangeLoggerKit"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/jpsim/Yams", .exact("1.0.1")),
    .package(url: "https://github.com/apple/swift-package-manager.git", .branch("swift-5.0-branch"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "ChangeLogger",
      dependencies: ["ChangeLoggerCLI"]
    ),
    .target(
      name: "ChangeLoggerCLI",
      dependencies: ["ChangeLoggerKit", "SPMUtility"]
    ),
    .target(
      name: "ChangeLoggerKit",
      dependencies: ["Yams"]
    ),
    .testTarget(
      name: "ChangeLoggerKitTests",
      dependencies: ["ChangeLoggerKit", "Yams"]
    ),
    .testTarget(
      name: "ChangeLoggerTests",
      dependencies: ["ChangeLogger", "ChangeLoggerKit"]
    )
  ]
)
