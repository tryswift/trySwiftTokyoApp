import AppFeature
import SwiftUI
import SwiftData

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
