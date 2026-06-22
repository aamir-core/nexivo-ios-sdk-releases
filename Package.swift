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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.6/NexivoWidget.xcframework.zip",
              checksum: "b6e22a83a99c5b5843d9e829692e53325021600e51fb81e9a47e376e2b53e871"
          ),
          .target(
              name: "NexivoWidget",
              dependencies: [
                  "NexivoWidgetCore",
                  .product(name: "LiveKit", package: "client-sdk-swift")
              ],
              path: "Sources/NexivoWidget"        
          )
      ]
  )
