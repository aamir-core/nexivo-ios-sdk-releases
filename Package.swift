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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.2.1/NexivoWidgetCore.xcframework.zip",
              checksum: "552a02228f208bf4814d2e3dc19dc4a47f4b03847bf2b922d5890f634898acd7"
          ),
          .target(
              name: "NexivoWidget",
              dependencies: [  
                  "NexivoWidgetCore",
                  .product(name: "LiveKit", package: "client-sdk-swift")
              ]
          )
      ]
  )
