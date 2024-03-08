import ComposableArchitecture
import Foundation
import ScheduleFeature
import SpeakerFeature
import SponsorFeature
import SwiftUI

@Reducer
public struct AppReducer {
  @ObservableState
  public struct State: Equatable {


    var schedule = Schedule.State()
    var speaker = Speaker.State()
    var sponsor = Sponsor.State()

    public init() {}
  }

  public enum Action {
    case schedule(Schedule.Action)
    case speaker(Speaker.Action)
    case sponsor(Sponsor.Action)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(state: \.schedule, action: \.schedule) {
      Schedule()
    }
    Scope(state: \.speaker, action: \.speaker) {
      Speaker()
    }
    Scope(state: \.sponsor, action: \.sponsor) {
      Sponsor()
    }
  }
}

public struct AppView: View {
  var store: StoreOf<AppReducer>

  public init(store: StoreOf<AppReducer>) {
    self.store = store
  }

  public var body: some View {
    TabView {
      ScheduleView(store: store.scope(state: \.schedule, action: \.schedule))
        .tabItem {
          Label(String(localized: "Schedule", bundle: .module), systemImage: "calendar")
        }
      SpeakerView(store: store.scope(state: \.speaker, action: \.speaker))
        .tabItem {
          Label(String(localized: "Speakers", bundle: .module), systemImage: "person.wave.2")
        }
      SponsorView(store: store.scope(state: \.sponsor, action: \.sponsor))
        .tabItem {
          Label(String(localized: "Sponsors", bundle: .module), systemImage: "building.2")
        }
      Text("About")
        .tabItem {
          Image(.rikoTokyo)
          Text("About", bundle: .module)
        }
    }
  }
}

#Preview {
  AppView(store: .init(initialState: .init(), reducer: {
    AppReducer()
  }))
}
