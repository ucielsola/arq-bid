// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ArqBid",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ArqBid", targets: ["ArqBid"])
    ],
    targets: [
        .executableTarget(
            name: "ArqBid"
        )
    ]
)
