import AppFeature
import SwiftUI

@main
struct ConfenrenceApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: .init(initialState: .init()) {
        AppReducer()
      })
    }
  }
}
