import Dependencies
import DependenciesMacros
import SharedModels
import Foundation

@DependencyClient
public struct FileClient {
  public var loadFavorites: @Sendable () throws -> Favorites
  public var saveFavorites: @Sendable (Favorites) throws -> Void
}

extension FileClient: DependencyKey {
  static public var liveValue: FileClient = .init(
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

  static func saveDataToUserDefaults(_ favorites : Favorites, as key: String) {
    let data = try? jsonEncoder.encode(favorites)
    UserDefaults.standard.set(data, forKey: key)
  }

  static func loadDataFromUserDefaults(key: String) -> Data? {
    return UserDefaults.standard.data(forKey: key)
  }
}

let jsonEncoder = {
  $0.dateEncodingStrategy = .iso8601
  $0.keyEncodingStrategy = .convertToSnakeCase
  return $0
}(JSONEncoder())
