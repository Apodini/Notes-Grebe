// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Grebe-Generated",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6),
    ],
    products: [
        .library(name: "Grebe-Generated", targets: ["Grebe-Generated"])
    ],
    dependencies: [
        .package(
            name: "Grebe",
            url: "https://github.com/Apodini/Grebe", from: Version("0.0.5")
        )
    ],
    targets: [
        .target(
            name: "Grebe-Generated",
            dependencies: [
                .product(name: "Grebe-Framework", package: "Grebe")
            ]
        )
    ]
)
