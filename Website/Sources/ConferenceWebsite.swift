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
    let websiteDirectory = try URL.selectDirectories(from: #file).source
    let websiteAssetsDirectory = websiteDirectory.appending(path: "Assets")
    let iosAppDirectory = websiteDirectory.deletingLastPathComponent().appending(path: "MyLibrary")

    let sponsorMediaDirectory = iosAppDirectory.appending(path: "Sources/SponsorFeature/Media.xcassets")
    let sponsorMediaEnumerator = FileManager.default.enumerator(at: sponsorMediaDirectory, includingPropertiesForKeys: nil)
    while let file = sponsorMediaEnumerator?.nextObject() as? URL {
      if file.pathExtension == "png" {
        let destURL = websiteAssetsDirectory.appendingPathComponent("images/from_app/\(file.lastPathComponent)")
        do {
          try FileManager.default.copyItem(at: file, to: destURL)
          print("Copied \(file.lastPathComponent) to \(destURL.path)")
        } catch {
          // It may already be copied
        }
      }
    }
  }
}

struct ConferenceSite2025: Site {
  var name = "try! Swift Tokyo"
  var url = URL(string: "https://tryswift.jp")!

  var homePage = Home()
  var theme = MainTheme()
}
