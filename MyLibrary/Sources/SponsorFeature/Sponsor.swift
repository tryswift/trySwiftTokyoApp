import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct Sponsor {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {

  }

  public init() {}

  public var body: some ReducerOf<Self> {
    EmptyReducer()
  }
}

public struct SponsorView: View {
  var store: StoreOf<Sponsor>

  public init(store: StoreOf<Sponsor>) {
    self.store = store
  }

  public var body: some View {
    Text("Sponsor")
  }
}
