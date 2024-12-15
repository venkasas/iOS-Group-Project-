// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Capstone_Project_A3",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Capstone_Project_A3",
            targets: ["Capstone_Project_A3"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Capstone_Project_A3"),
        .testTarget(
            name: "Capstone_Project_A3Tests",
            dependencies: ["Capstone_Project_A3"]),
    ]
)
