// swift-tools-version: 5.9
  import PackageDescription

  let package = Package(
      name: "NexivoWidget",
      platforms: [.iOS(.v15)],
      products: [
          .library(name: "NexivoWidgetSDK", targets: ["NexivoWidgetSDK"])
      ],
      dependencies: [
          .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.5.0")
      ],
      targets: [
          .binaryTarget(
              name: "NexivoWidgetCore",
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.10/NexivoWidgetCore.xcframework.zip",
              checksum: "29e17e7e8e6b3d5c22ade6b8ad3faa98de9ba6318ef52afe3421e70c5555f5ad"
          ),
          .target(
              name: "NexivoWidgetSDK",
              dependencies: [
                  "NexivoWidgetCore",
                  .product(name: "LiveKit", package: "client-sdk-swift")
              ],
              path: "Sources/NexivoWidgetSDK"
          )
      ]
  )
