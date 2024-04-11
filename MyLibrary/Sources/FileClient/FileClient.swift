import Dependencies
import DependenciesMacros
import SharedModels
import Foundation

public typealias Favorites = [String: [Session]]

@DependencyClient
public struct FileClient {
  public var loadFavorites: @Sendable () throws -> Favorites
  public var saveFavorites: @Sendable (Favorites) throws -> Void
}

extension FileClient: DependencyKey {
  static public var liveValue: FileClient = .init(
    loadFavorites: {
      guard let saveData = serialize(from: "Favorites") else {
        return [:]
      }
      let response = try jsonDecoder.decode(Favorites.self, from: saveData)
      return response
    },
    saveFavorites: { favorites in
      guard let data = try? jsonEncoder.encode(favorites) else {
        return
      }
      deserialize(data: data, into: "Favorites")
    }
  )

  static func deserialize(data : Data, into filePath: String) {
    guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return
    }
    let fileURL = documentPath.appendingPathComponent(filePath + ".json")
    try? data.write(to: fileURL)
  }

  static func serialize(from filePath: String) -> Data? {
    guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    let fileURL = documentPath.appendingPathComponent(filePath + ".json")
    return try? Data(contentsOf: fileURL)
  }
}

let jsonEncoder = {
  $0.dateEncodingStrategy = .iso8601
  $0.keyEncodingStrategy = .convertToSnakeCase
  return $0
}(JSONEncoder())

let jsonDecoder = {
  $0.dateDecodingStrategy = .iso8601
  $0.keyDecodingStrategy = .convertFromSnakeCase
  return $0
}(JSONDecoder())
