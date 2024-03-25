import AppFeature
import SwiftUI

@main
struct ConferenceApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(
        store: .init(initialState: .init()) {
          AppReducer()
        })
    }
  }
}
