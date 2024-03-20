public struct Favorites: Equatable, Codable {
  private var eachConferenceFavorites: [String: [Session]]

  public init(eachConferenceFavorites: [(conference: Conference, favoriteSessions: [Session])]) {
    self.eachConferenceFavorites = [:]
    for conferenceFavorites in eachConferenceFavorites {
      self.eachConferenceFavorites[conferenceFavorites.conference.title] = conferenceFavorites.favoriteSessions
    }
  }

  public mutating func updateFavoriteState(of session: Session, in conference: Conference) {
    guard var favorites = eachConferenceFavorites[conference.title] else {
      eachConferenceFavorites[conference.title] = [session]
      return
    }
    if favorites.contains(session) {
      eachConferenceFavorites[conference.title] = favorites.filter { $0 != session }
    } else {
      favorites.append(session)
      eachConferenceFavorites[conference.title] = favorites
    }
  }

  public func isFavorited(_ session: Session, in conference: Conference) -> Bool {
    guard let favorites = eachConferenceFavorites[conference.title] else {
      return false
    }
    return favorites.contains(session)
  }
}
