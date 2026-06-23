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
              checksum: "26c2a71cd5fdc559b78464d27b982bafc44cf898329da3bd0d39fe93dc7698c3"
          )
      ]
  )
