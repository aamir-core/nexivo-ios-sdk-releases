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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.9/NexivoWidgetSDK.xcframework.zip",
              checksum: "6f4180ac332954cc9c3b23bce3c100b1ad21a1f28622500e2aa5e76f238914b0"
          )
      ]
  )
