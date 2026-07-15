// swift-tools-version: 5.9
  import PackageDescription

  let package = Package(
      name: "NexivoWidget",
      platforms: [.iOS(.v15)],
      products: [
          .library(name: "NexivoWidget", targets: ["NexivoWidgetCore"])
      ],
      targets: [
          .binaryTarget(
              name: "NexivoWidgetCore",
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.5/NexivoWidgetSDK.xcframework.zip",
              checksum: "d4fa1f3df89fbbc4a8ab298c2dfaca9ceaf8b641f5bbcfe45ddb94a20fd50eea"
          )
      ]
  )
