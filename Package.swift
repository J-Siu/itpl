// swift-tools-version:6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "itpl",
	platforms: [.macOS(.v26)],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
	],
	targets: [
		.executableTarget(
			name: "itpl",
			dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")])
	],
	swiftLanguageModes: [.v6]
)
