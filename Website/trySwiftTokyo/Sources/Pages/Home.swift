import Foundation
import Ignite

struct Home: StaticPage {
  var title = "try! Swift Tokyo 2025"

  func body(context: PublishingContext) -> [BlockElement] {
    Text(title)
      .font(.title1)
    
    Section {
      Image("/images/riko_tokyo.svg", description: "Riko at Tokyo")
        .resizable()
        .frame(maxWidth: 250)
        .padding()
    }
    .horizontalAlignment(.center)
    .margin(.bottom, .extraLarge)
  }
}
