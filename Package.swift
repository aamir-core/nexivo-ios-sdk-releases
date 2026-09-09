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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.2.0/NexivoWidgetCore.xcframework.zip",
              checksum: "0b7743ddeef833e88271d672bd438b04de3b0c2e8e3c707d668c556b98161941"
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
