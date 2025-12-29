// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "URLQueryCoder",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "URLQueryCoder",
            targets: ["URLQueryCoder"]
        ),
        .library(
            name: "URLQueryCoderDynamic",
            type: .dynamic,
            targets: ["URLQueryCoder"]
        )
    ],
    targets: [
        .target(
            name: "URLQueryCoder",
            path: "Sources",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "URLQueryCoderTests",
            dependencies: ["URLQueryCoder"],
            path: "Tests",
            exclude: ["Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
