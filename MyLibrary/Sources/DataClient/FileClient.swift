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
      guard let saveData = loadDataFromFile(named: "Favorites") else {
        return .init(eachConferenceFavorites: [])
      }
      let response = try jsonDecoder.decode(Favorites.self, from: saveData)
      return response
    },
    saveFavorites: { favorites in
      guard let data = try? jsonEncoder.encode(favorites) else {
        return
      }
      saveDataToFile(data, named: "Favorites")
    }
  )

  static func saveDataToFile(_ data : Data, named fileName: String) {
    guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return
    }
    let fileURL = documentPath.appendingPathComponent(fileName + ".json")
    try? data.write(to: fileURL)
  }

  static func loadDataFromFile(named fileName: String) -> Data? {
    guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    let fileURL = documentPath.appendingPathComponent(fileName + ".json")
    return try? Data(contentsOf: fileURL)
  }
}

let jsonEncoder = {
  $0.dateEncodingStrategy = .iso8601
  $0.keyEncodingStrategy = .convertToSnakeCase
  return $0
}(JSONEncoder())
