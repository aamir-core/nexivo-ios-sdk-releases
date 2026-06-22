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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.8/NexivoWidgetSDK.xcframework.zip",
              checksum: "d05da14561649e4f54b12f8ca9679cac1a7392cb35852df8c432da0c894dfe08"
          )
      ]
  )
