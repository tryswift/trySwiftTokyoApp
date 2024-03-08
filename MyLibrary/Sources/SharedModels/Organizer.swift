import Foundation

public struct Organizer: Codable, Equatable, Hashable, Sendable {
  public var id: Int
  public var name: String
  public var imageName: String
  public var bio: String
  public var link: URL?

  public init(id: Int, name: String, imageName: String, bio: String, link: URL? = nil) {
    self.id = id
    self.name = name
    self.imageName = imageName
    self.bio = bio
    self.link = link
  }
}

