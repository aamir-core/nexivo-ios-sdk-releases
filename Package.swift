// swift-tools-version: 5.9
  import PackageDescription

  let package = Package(
      name: "NexivoWidget",
      platforms: [.iOS(.v15)],
      products: [
          .library(name: "NexivoWidget", targets: ["NexivoWidget"])
      ],
      dependencies: [
          .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.5.0")
      ],    
      targets: [
          .binaryTarget(
              name: "NexivoWidgetCore",
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.7/NexivoWidget.xcframework.zip",
              checksum: "08e7f34a67d91185dcfa01544c59a4f7f3550f2d2e608a9966b2508b214b9587"
          ),
          .target(
              name: "NexivoWidget",
              dependencies: [   
                  "NexivoWidgetCore",
                  .product(name: "LiveKit", package: "client-sdk-swift")
              ],
              path: "Sources/NexivoWidget"
          )
      ]
  )
