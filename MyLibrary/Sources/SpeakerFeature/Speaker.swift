import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct Speaker {
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

public struct SpeakerView: View {
  var store: StoreOf<Speaker>

  public init(store: StoreOf<Speaker>) {
    self.store = store
  }

  public var body: some View {
    Text("Speaker")
  }
}
