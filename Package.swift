// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Discourse",
    products: [
        .library(
            name: "Discourse",
            targets: ["Discourse"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Discourse",
            dependencies: []
        ),
        .testTarget(
            name: "DiscourseTests",
            dependencies: ["Discourse"]
        )
    ]
)
