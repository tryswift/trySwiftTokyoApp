import Cocoa
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

    let scheduleMediaDirectory = iosAppDirectory.appending(path: "Sources/ScheduleFeature/Media.xcassets")
    let scheduleMediaEnumerator = fileManager.enumerator(at: scheduleMediaDirectory, includingPropertiesForKeys: nil)

    try [sponsorMediaEnumerator, scheduleMediaEnumerator].forEach {
      while let file = $0?.nextObject() as? URL {
        let destURL = websiteAssetsDirectory.appendingPathComponent("images/from_app/\(file.deletingPathExtension().lastPathComponent).png")

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

        if file.pathExtension == "png" {
          try fileManager.copyItem(at: file, to: destURL)
        } else if let image = NSImage(contentsOf: file) {
          let pngData = NSBitmapImageRep(data: image.tiffRepresentation!)!
            .representation(using: .png, properties: [:])!
          try pngData.write(to: destURL)
        } else {
          continue
        }
      }
    }
  }
}

struct ConferenceSite2025: Site {
  var name = "try! Swift Tokyo"
  var url = URL(string: "https://tryswift.jp")!

  var homePage = Home(language: .ja)
  var layout = MainLayout()
  var darkTheme: (any Theme)? = nil

  var staticLayouts: [any StaticLayout] {
    for language in Language.allCases {
      Home(language: language)
      FAQ(language: language)
      CodeOfConduct(language: language)
      PrivacyPolicy(language: language)
    }
  }
}
