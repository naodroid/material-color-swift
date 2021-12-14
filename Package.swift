
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MaterialColorSwift",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "MaterialColorSwift",
            targets: ["MaterialColorSwift"]
        ),
        .library(
            name: "MaterialColorIOS",
            targets: ["MaterialColorIOS"]
        )
    ],
    targets: [
        .target(
            name: "MaterialColorSwift",
            path: "MaterialColorSwift"
        ),
        .target(
            name: "MaterialColorIOS",
            dependencies: ["MaterialColorSwift"],
            path: "MaterialColorIOS"
        ),
        .testTarget(
            name: "MaterialColorSwiftTests",
            dependencies: ["MaterialColorSwift"],
            path: "MaterialColorSwiftTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
