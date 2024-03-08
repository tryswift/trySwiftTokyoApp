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
  public var fetchSpeaker: @Sendable (_ name: String) throws -> Speaker?
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
    fetchSpeaker: { name in
      let data = loadDataFromBundle(fileName: "speaker")
      let response = try jsonDecoder.decode([Speaker].self, from: data)
      let speaker = response.filter { $0.name == name }.first
      return speaker
    }
  )

  static func loadDataFromBundle(fileName: String) -> Data {
    let filePath = Bundle.module.path(forResource: fileName, ofType: "json")!
    let fileURL = URL(fileURLWithPath: filePath)
    let data = try! Data(contentsOf: fileURL)
    return data
  }
}

let jsonDecoder = {
  $0.dateDecodingStrategy = .iso8601
  $0.keyDecodingStrategy = .convertFromSnakeCase
  return $0
}(JSONDecoder())
