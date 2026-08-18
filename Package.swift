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
              checksum: "788d2bff3053fb3a1088bb91abb52e5225d5a622df2516f697cb21bac50f9859"
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
