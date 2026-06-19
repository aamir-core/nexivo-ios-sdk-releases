// swift-tools-version: 5.9
  import PackageDescription
  
  let package = Package(
      name: "NexivoWidget",
      platforms: [.iOS(.v15)],
      products: [
          .library(name: "NexivoWidget", targets: ["NexivoWidget"])
      ],
      targets: [
          .binaryTarget(
              name: "NexivoWidget",
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases
  /releases/download/v1.0.5/NexivoWidget.xcframework.zip",
              checksum: "51cf80ef95f22c90545dec3a533e0ee780cdc0351bb36a7f6e997f44716ee2a9"
          )
      ]
  )
