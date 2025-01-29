import Foundation
import Ignite

struct MainFooter: RootHTML {
  var body: some HTML {
    Column {
      Text {
        Link("行動規範", target: URL(static: "https://tryswift.jp/code-of-conduct"))
          .role(.light)
          .margin(.trailing, .small)
        Link("プライバシーポリシー", target: URL(static: "https://tryswift.jp/privacy-policy"))
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
