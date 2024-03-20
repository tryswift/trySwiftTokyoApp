import ComposableArchitecture
import Foundation
import Safari
import SharedModels
import SwiftUI

@Reducer
public struct Profile {
  @ObservableState
  public struct State: Equatable {
    var organizer: Organizer

    public init(organizer: Organizer) {
      self.organizer = organizer
    }
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)

    public enum View {
      case snsTapped(URL)
    }
  }

  @Dependency(\.openURL) var openURL

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .view(.snsTapped(url)):
        let canOpenInSafari = UIApplication.shared.openInSFSafariViewIfEnabled(url: url)
        if canOpenInSafari {
          return .none
        }
        return .run { _ in await openURL(url) }
      case .binding:
        return .none
      }
    }
  }
}

@ViewAction(for: Profile.self)
public struct ProfileView: View {

  @Bindable public var store: StoreOf<Profile>

  public init(store: StoreOf<Profile>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        VStack {
          Image(store.organizer.imageName, bundle: .module)
            .resizable()
            .aspectRatio(1.0, contentMode: .fill)
            .frame(maxWidth: 400)
          VStack {
            if let links = store.organizer.links {
              HStack {
                ForEach(links, id: \.self) { link in
                  Button(link.name) {
                    send(.snsTapped(link.url))
                  }
                }
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
            }
          }
        }
        Text(LocalizedStringKey(store.organizer.bio), bundle: .module)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .frame(maxWidth: 700)
      }
      .navigationTitle(Text(LocalizedStringKey(store.organizer.name), bundle: .module))
    }
  }
}
