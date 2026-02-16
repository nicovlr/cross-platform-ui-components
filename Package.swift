// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CrossUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "CrossUI", targets: ["CrossUI"]),
    ],
    targets: [
        .target(
            name: "CrossUI",
            path: "Sources/SwiftUI"
        ),
        .target(
            name: "CrossUIKit",
            path: "Sources/UIKit"
        ),
        .target(
            name: "CrossUICpp",
            path: "Sources/Cpp",
            sources: ["src"],
            publicHeadersPath: "include",
            cxxSettings: [.define("CROSSUI_BUILDING")]
        ),
        .testTarget(
            name: "CrossUITests",
            dependencies: ["CrossUI"],
            path: "Tests/SwiftTests"
        ),
    ],
    cxxLanguageStandard: .cxx17
)
