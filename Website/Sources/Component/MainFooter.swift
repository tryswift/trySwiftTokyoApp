import Foundation
import Ignite

struct MainFooter: Component {
  func body(context: PublishingContext) -> [any PageElement] {
    Column {
      Text {
        Link("行動規範", target: URL("https://tryswift.jp/code-of-conduct"))
          .margin(.trailing, .small)
        Link("プライバシーポリシー", target: URL("https://tryswift.jp/privacy-policy"))
      }
      .font(.body)
      .fontWeight(.semibold)
      .horizontalAlignment(.center)

      Text("© 2016 try! Swift Tokyo")
        .font(.body)
        .fontWeight(.light)
        .horizontalAlignment(.center)
    }
  }
}
