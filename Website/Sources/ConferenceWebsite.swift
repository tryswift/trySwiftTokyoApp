import Foundation
import Ignite

@main
struct ConferenceWebsite {
  static func main() async {
    let site = ConferenceSite2025()

    do {
      try await site.publish()
    } catch {
      print(error.localizedDescription)
    }
  }
}

struct ConferenceSite2025: Site {
  var name = "try! Swift Tokyo"
  var url = URL(string: "https://tryswift.jp")!

  var homePage = Home()
  var theme = MainTheme()
}
