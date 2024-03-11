import AppFeature
import SwiftUI

@main
struct AppClipApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: .init(initialState: .init()) {
        AppReducer()
      })
    }
  }
}
