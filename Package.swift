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
              checksum: "2c7ebef7ca2b5076a7daea90b4d071a4343b53ce2a480cf9aff8c70cd9091b14"
          )
      ]
  )
