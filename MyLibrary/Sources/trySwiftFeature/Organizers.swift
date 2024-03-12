import ComposableArchitecture
import DataClient
import SwiftUI
import SharedModels

@Reducer
public struct Organizers {
  @ObservableState
  public struct State: Equatable {
    var organizers = IdentifiedArrayOf<Organizer>()
    @Presents var destination: Destination.State?
  }

  public enum Action: ViewAction {
    case view(View)
    case destination(PresentationAction<Destination.Action>)

    public enum View {
      case organizerTapped(Organizer)
    }
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case profile(Profile)
  }

  public var body: some ReducerOf<Organizers> {
    Reduce { state, action in
      switch action {
        case let .view(.organizerTapped(organizer)):
          state.destination = .profile(.init(organizer: organizer))
          return .none
        case .destination:
          return .none
      }
    }
  }
}

@ViewAction(for: Organizers.self)
public struct OrganizersView: View {

  public var store: StoreOf<Organizers>

  public var body: some View {
    List {
      ForEach(store.organizers) { organizer in
        Label {
          Text(LocalizedStringKey(organizer.name), bundle: .module)
        } icon: {
          Image(organizer.imageName, bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
        }
        .onTapGesture {
          send(.organizerTapped(organizer))
        }
      }
    }
    .navigationTitle(Text("Meet Organizers", bundle: .module))
  }
}

#Preview {
  OrganizersView(store: .init(initialState: .init(), reducer: {
    Organizers()
  }))
}
