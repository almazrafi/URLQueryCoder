// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "URLQueryCoder",
    products: [
        .library(
            name: "URLQueryCoder",
            targets: ["URLQueryCoder"]
        )
    ],
    targets: [
        .target(
            name: "URLQueryCoder",
            path: "Sources"
        ),
        .testTarget(
            name: "URLQueryCoderTests",
            dependencies: ["URLQueryCoder"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
