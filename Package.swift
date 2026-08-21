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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.1.2/NexivoWidgetCore.xcframework.zip",
              checksum: "d31b41d572054fefddff3ac7996884e2d3501f7ac263d911d4cb41a4462d111f"
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
