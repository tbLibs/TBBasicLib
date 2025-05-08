// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "TBBasicLib",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "TBBasicLib",
            targets: ["TBBasicLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scalessec/Toast-Swift.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "TBBasicLib",
            dependencies: [
                .product(name: "Toast", package: "Toast-Swift")
            ],
            path: "TBBasicLib/Classes"
        )
    ],
    swiftLanguageVersions: [.v5]
)

