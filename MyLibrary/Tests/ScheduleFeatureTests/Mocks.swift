import Foundation
import SharedModels

@testable import ScheduleFeature

extension Conference {
  static let mock1 = Self(
    id: 1,
    title: "conference1",
    date: Date(timeIntervalSince1970: 1_000),
    schedules: [
      .init(
        time: Date(timeIntervalSince1970: 10_000),
        sessions: [
          .mock1,
          .mock2,
        ]
      )
    ]
  )

  static let mock2 = Self(
    id: 2,
    title: "conference2",
    date: Date(timeIntervalSince1970: 2_000),
    schedules: [
      .init(
        time: Date(timeIntervalSince1970: 20_000),
        sessions: [
          .mock1,
          .mock2,
        ]
      )
    ]
  )

  static let mock3 = Self(
    id: 3,
    title: "conference3",
    date: Date(timeIntervalSince1970: 3_000),
    schedules: [
      .init(
        time: Date(timeIntervalSince1970: 30_000),
        sessions: [
          .mock1,
          .mock2,
        ]
      )
    ]
  )
}

extension Session {
  static let mock1 = Self(
    title: "session1",
    speakers: [
      .mock1
    ],
    place: "place1",
    description: "description1",
    requirements: "requirements1"
  )

  static let mock2 = Self(
    title: "session2",
    speakers: [
      .mock2
    ],
    place: "place2",
    description: "description2",
    requirements: "requirements2"
  )
}

extension Speaker {
  static let mock1 = Self(
    name: "speaker1",
    imageName: "image1",
    bio: "bio1",
    links: [
      .init(
        name: "sns1",
        url: URL(string: "https://example.com/speaker1")!
      )
    ]
  )

  static let mock2 = Self(
    name: "speaker2",
    imageName: "image2",
    bio: "bio2",
    links: [
      .init(
        name: "sns2",
        url: URL(string: "https://example.com/speaker2")!
      )
    ]
  )
}

extension Favorites {
  static let mock1 = favoritedSession1InConference1
  static let favoritedSession1InConference1 = Self(eachConferenceFavorites: [
    (.mock1, [.mock1])
  ])
}

extension ScheduleFeature.Schedule.State {
  static let selectingDay1ScheduleWithNoFavorites = {
    var initialState = Schedule.State()
    initialState.selectedDay = .day1
    initialState.day1 = .mock1
    return initialState
  }()

  static let selectingDay1ScheduleWithOneFavorite = {
    var initialState = Schedule.State()
    initialState.selectedDay = .day1
    initialState.day1 = .mock1
    let firstSession = initialState.day1!.schedules.first!.sessions.first!
    initialState.favorites = .init(eachConferenceFavorites: [(initialState.day1!, [firstSession])])
    return initialState
  }()
}
