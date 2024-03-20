import ComposableArchitecture
import DataClient
import SharedModels
import XCTest

@testable import ScheduleFeature

final class ScheduleTests: XCTestCase {
  @MainActor
  func testFetchData() async {
    let store = TestStore(initialState: Schedule.State()) {
      Schedule()
    } withDependencies: {
      $0[DataClient.self].fetchDay1 = { @Sendable in .mock1 }
      $0[DataClient.self].fetchDay2 = { @Sendable in .mock2 }
      $0[DataClient.self].fetchWorkshop = { @Sendable in .mock3 }
      $0[FileClient.self].loadFavorites = { @Sendable in .mock1 }
    }
    await store.send(.view(.onAppear))
    await store.receive(\.fetchResponse.success) {
      $0.day1 = .mock1
      $0.day2 = .mock2
      $0.workshop = .mock3
      $0.favorites = .mock1
    }
  }

  @MainActor
  func testFetchDataFailure() async {
    struct FetchError: Equatable, Error {}
    let store = TestStore(initialState: Schedule.State()) {
      Schedule()
    } withDependencies: {
      $0[DataClient.self].fetchDay1 = { @Sendable in throw FetchError() }
      $0[DataClient.self].fetchDay2 = { @Sendable in .mock2 }
      $0[DataClient.self].fetchWorkshop = { @Sendable in .mock3 }
      $0[FileClient.self].loadFavorites = { @Sendable in .mock1 }
    }
    await store.send(.view(.onAppear))
    await store.receive(\.fetchResponse.failure)
  }

  @MainActor
  func testAddingFavorites() async {
    let initialState: ScheduleFeature.Schedule.State = .selectingDay1ScheduleWithNoFavorites
    let firstSession = initialState.day1!.schedules.first!.sessions.first!
    let firstSessionFavorited: Favorites = .init(eachConferenceFavorites: [(initialState.day1!, [firstSession])])
    let store = TestStore(initialState: initialState) {
      Schedule()
    } withDependencies: {
      $0[FileClient.self].saveFavorites = { @Sendable in XCTAssertEqual($0, firstSessionFavorited) }
    }

    await store.send(.view(.favoriteIconTapped(firstSession)))
    await store.receive(\.savedFavorites) {
      $0.favorites = firstSessionFavorited
    }
  }

  @MainActor
  func testRemovingFavorites() async {
    let initialState: ScheduleFeature.Schedule.State = .selectingDay1ScheduleWithOneFavorite
    let firstSession = initialState.day1!.schedules.first!.sessions.first!
    let noFavorites: Favorites = .init(eachConferenceFavorites: [(initialState.day1!, [])])
    let store = TestStore(initialState: initialState) {
      Schedule()
    } withDependencies: {
      $0[FileClient.self].saveFavorites = { @Sendable in XCTAssertEqual($0, noFavorites) }
    }

    await store.send(.view(.favoriteIconTapped(firstSession)))
    await store.receive(\.savedFavorites) {
      $0.favorites = noFavorites
    }
  }
}
