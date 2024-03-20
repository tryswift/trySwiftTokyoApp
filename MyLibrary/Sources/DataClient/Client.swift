import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

@DependencyClient
public struct DataClient {
  public var fetchDay1: @Sendable () throws -> Conference
  public var fetchDay2: @Sendable () throws -> Conference
  public var fetchWorkshop: @Sendable () throws -> Conference
  public var fetchSponsors: @Sendable () throws -> Sponsors
  public var fetchOrganizers: @Sendable () throws -> [Organizer]
  public var loadFavorites: @Sendable () throws -> Favorites
  public var saveFavorites: @Sendable (Favorites) throws -> Void
}

extension DataClient: DependencyKey {

  static public var liveValue: DataClient = .init(
    fetchDay1: {
      let data = loadDataFromBundle(fileName: "day1")
      let response = try jsonDecoder.decode(Conference.self, from: data)
      return response
    },
    fetchDay2: {
      let data = loadDataFromBundle(fileName: "day2")
      let response = try jsonDecoder.decode(Conference.self, from: data)
      return response
    },
    fetchWorkshop: {
      let data = loadDataFromBundle(fileName: "workshop")
      let response = try jsonDecoder.decode(Conference.self, from: data)
      return response
    },
    fetchSponsors: {
      let data = loadDataFromBundle(fileName: "sponsors")
      let response = try jsonDecoder.decode(Sponsors.self, from: data)
      return response
    },
    fetchOrganizers: {
      let data = loadDataFromBundle(fileName: "organizers")
      let response = try jsonDecoder.decode([Organizer].self, from: data)
      return response
    }, 
    loadFavorites: {
      guard let saveData = loadDataFromUserDefaults(key: "Favorites") else {
        return .init(eachConferenceFavorites: [])
      }
      let response = try jsonDecoder.decode(Favorites.self, from: saveData)
      return response
    },
    saveFavorites: { favorites in
      saveDataToUserDefaults(favorites, as: "Favorites")
    }
  )

  static func loadDataFromBundle(fileName: String) -> Data {
    let filePath = Bundle.module.path(forResource: fileName, ofType: "json")!
    let fileURL = URL(fileURLWithPath: filePath)
    let data = try! Data(contentsOf: fileURL)
    return data
  }

  static func saveDataToUserDefaults(_ favorites : Favorites, as key: String) {
    let data = try? jsonEncoder.encode(favorites)
    UserDefaults.standard.set(data, forKey: key)
  }

  static func loadDataFromUserDefaults(key: String) -> Data? {
    return UserDefaults.standard.data(forKey: key)
  }
}

let jsonDecoder = {
  $0.dateDecodingStrategy = .iso8601
  $0.keyDecodingStrategy = .convertFromSnakeCase
  return $0
}(JSONDecoder())

let jsonEncoder = {
  $0.dateEncodingStrategy = .iso8601
  $0.keyEncodingStrategy = .convertToSnakeCase
  return $0
}(JSONEncoder())
