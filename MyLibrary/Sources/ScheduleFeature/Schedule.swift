import ComposableArchitecture
import DataClient
import FileClient
import Foundation
import SharedModels
import SwiftUI
import TipKit

@Reducer
public struct Schedule {
  enum Days: LocalizedStringKey, Equatable, CaseIterable, Identifiable {
    case day1 = "Day 1"
    case day2 = "Day 2"
    case day3 = "Day 3"

    var id: Self { self }
  }

  public struct SchedulesResponse: Equatable {
    var day1: Conference
    var day2: Conference
    var workshop: Conference
  }

  @ObservableState
  public struct State: Equatable {

    var path = StackState<Path.State>()
    var selectedDay: Days = .day1
    var searchText: String = ""
    var isSearchBarPresented: Bool = false
    var day1: Conference?
    var day2: Conference?
    var workshop: Conference?
    var favorites: Favorites = [:]
    @Presents var destination: Destination.State?

    public init() {}
  }

  public enum Action: BindableAction, ViewAction {
    case binding(BindingAction<State>)
    case path(StackAction<Path.State, Path.Action>)
    case destination(PresentationAction<Destination.Action>)
    case view(View)
    case fetchResponse(Result<SchedulesResponse, Error>)
    case loadResponse(Result<Favorites, Error>)
    case savedFavorites(Session, Conference)

    public enum View {
      case onAppear
      case disclosureTapped(Session)
      case favoriteIconTapped(Session)
    }
  }

  @Reducer(state: .equatable)
  public enum Path {
    case detail(ScheduleDetail)
  }

  @Reducer(state: .equatable)
  public enum Destination {}

  @Dependency(DataClient.self) var dataClient
  @Dependency(FileClient.self) var fileClient

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .run { send in
          await send(
            .fetchResponse(
              Result {
                let day1 = try dataClient.fetchDay1()
                let day2 = try dataClient.fetchDay2()
                let workshop = try dataClient.fetchWorkshop()
                return .init(day1: day1, day2: day2, workshop: workshop)
              }))
          await send(
            .loadResponse(
              Result {
                try fileClient.loadFavorites()
              }))
        }
      case let .view(.disclosureTapped(session)):
        guard let description = session.description, let speakers = session.speakers else {
          return .none
        }
        state.path.append(
          .detail(
            .init(
              title: session.title,
              description: description,
              requirements: session.requirements,
              speakers: speakers
            )
          )
        )
        return .none
      case let .view(.favoriteIconTapped(session)):
        let conference = switch state.selectedDay {
        case .day1:
          state.day1!
        case .day2:
          state.day2!
        case .day3:
          state.workshop!
        }
        var favorites = state.favorites
        favorites.updateFavoriteState(of: session, in: conference)
        return .run { [favorites = favorites] send in
          try? fileClient.saveFavorites(favorites)
          await send(.savedFavorites(session, conference))
        }
      case let .savedFavorites(session, day):
        state.favorites.updateFavoriteState(of: session, in: day)
        return .none
      case let .fetchResponse(.success(response)):
        state.day1 = response.day1
        state.day2 = response.day2
        state.workshop = response.workshop
        return .none
      case let .fetchResponse(.failure(error as DecodingError)):
        assertionFailure(error.localizedDescription)
        return .none
      case let .fetchResponse(.failure(error)):
        print(error)  // TODO: replace to Logger API
        return .none
      case let .loadResponse(.success(response)):
        state.favorites = response
        return .none
      case let .loadResponse(.failure(error as DecodingError)):
        assertionFailure(error.localizedDescription)
        return .none
      case let .loadResponse(.failure(error)):
        print(error)  // TODO: replace to Logger API
        return .none
      case .binding, .path, .destination:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    .ifLet(\.$destination, action: \.destination)
  }
}

private extension Favorites {
  mutating func updateFavoriteState(of session: Session, in conference: Conference) {
    guard var favorites = self[conference.title] else {
      self[conference.title] = [session]
      return
    }
    if favorites.contains(session) {
      self[conference.title] = favorites.filter { $0 != session }
    } else {
      favorites.append(session)
      self[conference.title] = favorites
    }
  }
}

@ViewAction(for: Schedule.self)
public struct ScheduleView: View {

  @Bindable public var store: StoreOf<Schedule>

  public init(store: StoreOf<Schedule>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      root
    } destination: { store in
      switch store.state {
      case .detail:
        if let store = store.scope(state: \.detail, action: \.detail) {
          ScheduleDetailView(store: store)
        }
      }
    }
  }

  @ViewBuilder
  var root: some View {
    ScrollView {
      Picker("Days", selection: $store.selectedDay) {
        ForEach(Schedule.Days.allCases) { day in
          Text(day.rawValue, bundle: .module)
        }
      }
      .pickerStyle(.segmented)
      .padding(.horizontal)
      switch store.selectedDay {
      case .day1:
        if let day1 = store.day1 {
          conferenceList(conference: day1)
        } else {
          Text("")
        }
      case .day2:
        if let day2 = store.day2 {
          conferenceList(conference: day2)
        } else {
          Text("")
        }
      case .day3:
        if let workshop = store.workshop {
          conferenceList(conference: workshop)
        } else {
          Text("")
        }
      }
    }
    .onAppear(perform: {
      send(.onAppear)
    })
    .navigationTitle(Text("Schedule", bundle: .module))
    .searchable(text: $store.searchText, isPresented: $store.isSearchBarPresented)
  }

  @ViewBuilder
  func conferenceList(conference: Conference) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(conference.date, style: .date)
        .font(.title2)
      ForEach(conference.schedules, id: \.self) { schedule in
        VStack(alignment: .leading, spacing: 4) {
          Text(schedule.time, style: .time)
            .font(.subheadline.bold())
          ForEach(schedule.sessions, id: \.self) { session in
            if session.description != nil {
              Button {
                send(.disclosureTapped(session))
              } label: {
                listRow(session: session)
                  .padding()
              }
              .background(
                Color(uiColor: .secondarySystemBackground)
                  .clipShape(RoundedRectangle(cornerRadius: 8))
              )
            } else {
              listRow(session: session)
                .padding()
                .background(
                  Color(uiColor: .secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                )
            }
          }
        }
      }
    }
    .padding()
  }

  @ViewBuilder
  func listRow(session: Session) -> some View {
    HStack(spacing: 8) {
      VStack {
        if let speakers = session.speakers {
          ForEach(speakers, id: \.self) { speaker in
            Image(speaker.imageName, bundle: .module)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .clipShape(Circle())
              .background(
                Color(uiColor: .systemBackground)
                  .clipShape(Circle())
              )
              .frame(width: 60)
          }
        } else {
          Image(.tokyo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: 60)
        }
      }
      VStack(alignment: .leading) {
        if session.title == "Office hour", let speakers = session.speakers {
          let title = officeHourTitle(speakers: speakers)
          Text(title)
            .font(.title3)
            .multilineTextAlignment(.leading)
        } else {
          Text(LocalizedStringKey(session.title), bundle: .module)
            .font(.title3)
            .multilineTextAlignment(.leading)
        }
        if let speakers = session.speakers {
          Text(ListFormatter.localizedString(byJoining: speakers.map(\.name)))
            .foregroundStyle(Color.init(uiColor: .label))
            .multilineTextAlignment(.leading)
        }
        if let summary = session.summary {
          if session.title == "Office hour", let speakers = session.speakers {
            let description = officeHourDescription(speakers: speakers)
            Text(description)
              .foregroundStyle(Color(uiColor: .secondaryLabel))
          } else {
            Text(LocalizedStringKey(summary), bundle: .module)
              .foregroundStyle(Color(uiColor: .secondaryLabel))
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      favoriteIcon(for: session)
        .onTapGesture {
          send(.favoriteIconTapped(session))
        }
    }
  }

  @ViewBuilder
  func favoriteIcon(for session: Session) -> some View {
    let conference = 
    switch store.selectedDay {
    case .day1:
      store.day1!
    case .day2:
      store.day2!
    case .day3:
      store.workshop!
    }

    let isFavorited = {
      guard let favorites = store.favorites[conference.title] else {
        return false
      }
      return favorites.contains(session)
    }()
    if isFavorited {
      Image(systemName: "star.fill")
        .foregroundColor(.yellow)
    } else {
      Image(systemName: "star")
        .foregroundColor(.gray)
    }
  }

  func officeHourTitle(speakers: [Speaker]) -> String {
    let names = givenNameList(speakers: speakers)
    return String(localized: "Office hour \(names)", bundle: .module)
  }

  func officeHourDescription(speakers: [Speaker]) -> String {
    let names = givenNameList(speakers: speakers)
    return String(localized: "Office hour description \(names)", bundle: .module)
  }

  private func givenNameList(speakers: [Speaker]) -> String {
    let givenNames = speakers.compactMap {
      let name = $0.name
      let components = try! PersonNameComponents(name).givenName
      return components
    }
    let formatter = ListFormatter()
    return formatter.string(from: givenNames)!
  }
}

#Preview {
  ScheduleView(
    store: .init(
      initialState: .init(),
      reducer: {
        Schedule()
      }))
}
