import Foundation
import IdentifiedCollections
import MapKit
import SwiftUI

enum Lines: Equatable, Identifiable, CaseIterable {
  var id: Self { self }

  case metroShibuya
  case jrShibuya
  case metroOmotesando

  var localizedKey: LocalizedStringKey {
    switch self {
    case .metroShibuya:
      return "Metro Shibuya"
    case .jrShibuya:
      return "JR Shibuya"
    case .metroOmotesando:
      return "Omote-sando"
    }
  }

  var region: MKCoordinateRegion {
    switch self {
    case .metroShibuya:
      return .init(
        center: .init(latitude: 35.657892, longitude: 139.703748),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    case .jrShibuya:
      return .init(
        center: .init(latitude: 35.658575, longitude: 139.701499),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    case .metroOmotesando:
      return .init(
        center: .init(latitude: 35.665222, longitude: 139.712543),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
  }

  var searchQuery: String {
    switch self {
    case .jrShibuya:
      return "JR Shibuya Station"
    case .metroOmotesando:
      return "表参道駅 B1"
    case .metroShibuya:
      return "渋谷駅 C1"
    }
  }

  var exitName: LocalizedStringKey {
    switch self {
    case .metroShibuya:
      return "Exit C1"
    case .jrShibuya:
      return "JR Shibuya Station East Exit"
    case .metroOmotesando:
      return "Exit B1"
    }
  }

  var originTitle: LocalizedStringKey {
    switch self {
    case .metroShibuya:
      return "Shibuya Station C1 Exit"
    case .jrShibuya:
      return "Shibuya Station East Exit"
    case .metroOmotesando:
      return "Omote-sando Station B1 Exit"
    }
  }

  var itemColor: Color {
    switch self {
    case .metroShibuya:
      return Color.red
    case .jrShibuya:
      return Color.green
    case .metroOmotesando:
      return Color.purple
    }
  }

  var directions: IdentifiedArrayOf<Direction> {
    switch self {
    case .metroShibuya:
      return [
        .init(order: 1, description: "metro-1", imageName: "metro-1"),
        .init(order: 2, description: "jr-9", imageName: "jr-9"),
        .init(order: 3, description: "jr-10", imageName: "jr-10"),
        .init(order: 4, description: "jr-11", imageName: "jr-11"),
      ]
    case .jrShibuya:
      return [
        .init(order: 1, description: "jr-1", imageName: "jr-1"),
        .init(order: 2, description: "jr-2", imageName: "jr-2"),
        .init(order: 3, description: "jr-3", imageName: "jr-3"),
        .init(order: 4, description: "jr-4", imageName: "jr-4"),
        .init(order: 5, description: "jr-5", imageName: "jr-5"),
        .init(order: 6, description: "jr-6", imageName: "jr-6"),
        .init(order: 7, description: "jr-7", imageName: "jr-7"),
        .init(order: 8, description: "jr-8", imageName: "jr-8"),
        .init(order: 9, description: "jr-9", imageName: "jr-9"),
        .init(order: 10, description: "jr-10", imageName: "jr-10"),
        .init(order: 11, description: "jr-11", imageName: "jr-11"),
      ]
    case .metroOmotesando:
      return [
        .init(order: 1, description: "omotesando-1", imageName: "jr-11")
      ]
    }
  }

  var duration: Duration {
    switch self {
    case .metroShibuya:
      return .seconds(6 * 60)
    case .jrShibuya:
      return .seconds(8 * 60)
    case .metroOmotesando:
      return .seconds(10 * 60)
    }
  }

  struct Direction: Equatable, Identifiable {
    var id: UUID { .init() }
    var order: Int
    var description: LocalizedStringKey
    var imageName: String
  }
}
