// swift-tools-version: 5.9
  import PackageDescription

  let package = Package(
      name: "NexivoWidget",
      platforms: [.iOS(.v15)],
      products: [
          .library(name: "NexivoWidgetSDK", targets: ["NexivoWidgetSDK"])
      ],
      targets: [
          .binaryTarget(
              name: "NexivoWidgetSDK",
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.10/NexivoWidgetSDK.xcframework.zip",
              checksum: "29e17e7e8e6b3d5c22ade6b8ad3faa98de9ba6318ef52afe3421e70c5555f5ad"
          )
      ]
  )
