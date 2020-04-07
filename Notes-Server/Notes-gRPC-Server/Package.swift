// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Notes-gRPC-Server",
    dependencies: [
        .package(name: "GRPC", url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0-alpha.7")
    ],
    targets: [
        .target(name: "Notes-gRPC-Server", dependencies: ["GRPC"])
    ]
)
