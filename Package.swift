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
              url: "https://github.com/aamir-core/nexivo-ios-sdk-releases/releases/download/v1.0.7/NexivoWidget.xcframework.zip",
              checksum: "08e7f34a67d91185dcfa01544c59a4f7f3550f2d2e608a9966b2508b214b9587"
          )
      ]
  )
