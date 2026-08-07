// swift-tools-version: 5.9
  import PackageDescription    

  let package = Package(
      name: "nexivo-ios-sdk-release",   // must match URL-derived identity
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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.1.0/NexivoWidgetCore.xcframework.zip",
              checksum: "0b7562def54819f35c45a3eeb49b59b20615a37e8837c1c62116497d16e3952d"
          )
      ]                        
  )
