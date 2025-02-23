// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PaymentSDK",
    platforms: [
        .iOS(.v14),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "PaymentSDK",
            targets: ["PaymentSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PaymentSDK",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "PaymentSDKTests",
            dependencies: ["PaymentSDK"],
            path: "Tests"
        ),
    ]
)
