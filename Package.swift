// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Magnet",
    platforms: [
      .macOS(.v10_9)
    ],
    products: [
        .library(
            name: "Magnet",
            targets: ["Magnet"]),
    ],
    targets: [
        .target(
            name: "Magnet",
            dependencies: [],
            path: "Lib/Magnet"),
        .testTarget(
            name: "MagnetTests",
            dependencies: ["Magnet"],
            path: "Lib/MagnetTests"),
    ],
    swiftLanguageVersions: [.v5]
)
