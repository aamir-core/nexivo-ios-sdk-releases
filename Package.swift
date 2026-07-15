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
              checksum: "2eed0186476a783ef22e2223f13216a5f608d72737383da568254b5179786c00"
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
