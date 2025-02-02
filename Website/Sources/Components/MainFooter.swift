import Foundation
import Ignite

struct MainFooter: RootHTML {
  let language: Language

  var body: some HTML {
    Column {
      Text {
        Link(String(forKey: "code_of_conduct", language: language), target: CodeOfConduct(language: language))
          .role(.light)
          .margin(.trailing, .small)
        Link(String(forKey: "privacy_policy", language: language), target: PrivacyPolicy(language: language))
          .role(.light)
      }
      .horizontalAlignment(.center)
      .font(.body)
      .fontWeight(.semibold)

      Text("© 2016 try! Swift Tokyo")
        .horizontalAlignment(.center)
        .font(.body)
        .fontWeight(.light)
    }
  }
}
