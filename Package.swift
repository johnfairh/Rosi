// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Rosi",
  platforms: [
    .macOS("12.0"),
  ],
  dependencies: [
    .package(url: "https://github.com/johnfairh/TMLEngines",
             from: "1.3.0")
  ],
  targets: [
    .executableTarget(
      name: "Rosi",
      dependencies: [
        .product(name: "MetalEngine", package: "TMLEngines"),
      ])
    ]
)
