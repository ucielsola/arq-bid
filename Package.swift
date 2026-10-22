// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ArqBid",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "ArqBidCore", targets: ["ArqBidCore"]),
        .executable(name: "ArqBid", targets: ["ArqBid"]),
        .executable(name: "ArqBidWidget", targets: ["ArqBidWidget"])
    ],
    targets: [
        .target(name: "ArqBidCore"),
        .executableTarget(
            name: "ArqBid",
            dependencies: ["ArqBidCore"]
        ),
        .executableTarget(
            name: "ArqBidWidget",
            dependencies: ["ArqBidCore"],
            path: "Sources/ArqBidWidget"
        ),
        .executableTarget(
            name: "ArqBidCoreChecks",
            dependencies: ["ArqBidCore"],
            path: "Tests/ArqBidCoreTests"
        )
    ]
)
