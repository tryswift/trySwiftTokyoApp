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
  public var saveDay1: @Sendable (Conference) throws -> Void
  public var saveDay2: @Sendable (Conference) throws -> Void
  public var saveWorkshop: @Sendable (Conference) throws -> Void
}

extension DataClient: DependencyKey {
  private static let day1 = "day1"
  private static let day2 = "day2"
  private static let workshop = "workshop"

  static public var liveValue: DataClient = .init(
    fetchDay1: {
      let data = loadData(dayOf: day1)
      let response = try jsonDecoder.decode(Conference.self, from: data)
      return response
    },
    fetchDay2: {
      let data = loadData(dayOf: day2)
      let response = try jsonDecoder.decode(Conference.self, from: data)
      return response
    },
    fetchWorkshop: {
      let data = loadData(dayOf: workshop)
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
    saveDay1: { conference in
      saveDataToUserDefaults(conference, as: day1)
    },
    saveDay2: { conference in
      saveDataToUserDefaults(conference, as: day2)
    },
    saveWorkshop: { conference in
      saveDataToUserDefaults(conference, as: workshop)
    }
  )

  static func loadData(dayOf day: String) -> Data {
    if let saveData = loadDataFromUserDefaults(key: day) {
      return saveData
    }
    return loadDataFromBundle(fileName: day)
  }

  static func loadDataFromBundle(fileName: String) -> Data {
    let filePath = Bundle.module.path(forResource: fileName, ofType: "json")!
    let fileURL = URL(fileURLWithPath: filePath)
    let data = try! Data(contentsOf: fileURL)
    return data
  }

  static func saveDataToUserDefaults(_ conference : Conference, as key: String) {
    let data = try? jsonEncoder.encode(conference)
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
