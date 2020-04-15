// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Notes-gRPC-Server",
    dependencies: [
        .package(name: "GRPC", url: "https://github.com/grpc/grpc-swift.git", .exact("1.0.0-alpha.8"))
    ],
    targets: [
        .target(name: "Notes-gRPC-Server", dependencies: ["GRPC"])
    ]
)
