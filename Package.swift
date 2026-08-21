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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.1.1/NexivoWidgetCore.xcframework.zip",
              checksum: "6e77d06fde014c794cabfd789ffcf05c42588e2efac026b52d54ed2de201bc7a"
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
