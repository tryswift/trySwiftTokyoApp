import Foundation
import Ignite

@main
struct ConferenceWebsite {
  static func main() async {
    let site = ConferenceSite2025()

    do {
      try copyAssets()

      try await site.publish()
    } catch {
      print(error.localizedDescription)
    }
  }

  private static func copyAssets() throws {
    let fileManager = FileManager.default

    let websiteDirectory = try URL.selectDirectories(from: #file).source
    let websiteAssetsDirectory = websiteDirectory.appending(path: "Assets")
    let iosAppDirectory = websiteDirectory.deletingLastPathComponent().appending(path: "MyLibrary")

    let sponsorMediaDirectory = iosAppDirectory.appending(path: "Sources/SponsorFeature/Media.xcassets")
    let sponsorMediaEnumerator = fileManager.enumerator(at: sponsorMediaDirectory, includingPropertiesForKeys: nil)
    while let file = sponsorMediaEnumerator?.nextObject() as? URL {
      if file.pathExtension == "png" {
        let destURL = websiteAssetsDirectory.appendingPathComponent("images/from_app/\(file.lastPathComponent)")

        let destinationDirectory = destURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: destinationDirectory.path) {
          try fileManager.createDirectory(
            at: destinationDirectory,
            withIntermediateDirectories: true,
            attributes: nil
          )
        }

        if fileManager.fileExists(atPath: destURL.path) {
          try fileManager.removeItem(at: destURL)
        }

        try fileManager.copyItem(at: file, to: destURL)
        print("Copied \(file.lastPathComponent) to \(destURL.path)")
      }
    }
  }
}

struct ConferenceSite2025: Site {
  var name = "try! Swift Tokyo"
  var url = URL(string: "https://tryswift.jp")!

  var homePage = Home(language: .ja)
  var theme = MainTheme()
}
