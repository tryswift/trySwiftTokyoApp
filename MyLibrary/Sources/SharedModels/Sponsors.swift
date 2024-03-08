import Foundation

public enum Plan: String, Codable, Sendable, CaseIterable {
  case platinum
  case gold
  case silver
  case bronze
  case diversityAndInclusion
  case student
  case community
  case individual
}

public struct Sponsors: Codable, Equatable, Hashable, Sendable {
  public var plans: [Plan: Sponsor]

  public init(plans: [Plan : Sponsor]) {
    self.plans = plans
  }
}

public struct Sponsor: Codable, Equatable, Hashable, Identifiable, Sendable {
  public var id: Int
  public var name: String
  public var imageName: String
  public var link: URL?

  public init(id: Int, name: String, imageName: String, link: URL? = nil) {
    self.id = id
    self.name = name
    self.imageName = imageName
    self.link = link
  }
}
