// swift-tools-version:6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "itpl",
	platforms: [.macOS(.v26)],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
		.package(url: "https://github.com/gewill/SwiftyOpenCC.git", branch: "master"),
	],
	targets: [
		.executableTarget(
			name: "itpl",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "OpenCC", package: "SwiftyOpenCC"),
			])
	],
	swiftLanguageModes: [.v6]
)

// cspell:words Swifty
