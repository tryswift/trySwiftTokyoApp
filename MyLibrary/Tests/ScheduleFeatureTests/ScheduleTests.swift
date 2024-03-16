import ComposableArchitecture
import XCTest

@testable import DataClient
@testable import ScheduleFeature

final class ScheduleTests: XCTestCase {
  @MainActor
  func testFetchData() async {
    let store = TestStore(initialState: Schedule.State()) {
      Schedule()
    } withDependencies: {
      $0.dataClient.fetchDay1 = { @Sendable in .mock1 }
      $0.dataClient.fetchDay2 = { @Sendable in .mock2 }
      $0.dataClient.fetchWorkshop = { @Sendable in .mock3 }
    }
    await store.send(.view(.onAppear)) {
      $0.day1 = .mock1
      $0.day2 = .mock2
      $0.workshop = .mock3
    }
  }
}
