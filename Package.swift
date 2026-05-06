// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Magnet",
    platforms: [
      .macOS(.v11)
    ],
    products: [
        .library(
            name: "Magnet",
            targets: ["Magnet"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Clipy/Sauce", .upToNextMinor(from: "2.4.0")),
    ],
    targets: [
        .target(
            name: "Magnet",
            dependencies: ["Sauce"],
            path: "Lib/Magnet",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "MagnetTests",
            dependencies: ["Magnet"],
            path: "Lib/MagnetTests",
            exclude: ["Info.plist"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
