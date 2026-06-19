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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.5/NexivoWidget.xcframework.zip",
              checksum: "87788e5825433edee06d8c91c5ae48697792d27b6df0add3d29828053d0baee3"
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
