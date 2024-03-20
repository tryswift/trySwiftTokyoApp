import ComposableArchitecture
import Safari
import SwiftUI

@Reducer
public struct Acknowledgements {
  @ObservableState
  public struct State: Equatable {
    var packages = LicenseProvider.packages

    public init() {}
  }

  public enum Action {
    case urlTapped(URL)
  }

  @Dependency(\.openURL) var openURL

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .urlTapped(url):
        let canOpenInSafari = UIApplication.shared.openInSFSafariViewIfEnabled(url: url)
        if canOpenInSafari {
          return .none
        }
        return .run { _ in await openURL(url) }
      }
    }
  }
}

public struct AcknowledgementsView: View {

  @Bindable public var store: StoreOf<Acknowledgements>

  public var body: some View {
    List {
      ForEach(store.packages, id: \.self) { package in
        NavigationLink(package.name) {
          ScrollView {
            Button(package.location.absoluteString) {
              store.send(.urlTapped(package.location))
            }
            .padding()
            Text(package.license)
              .padding()
          }
          .navigationTitle(package.name)
        }
      }
    }
    .navigationTitle(Text("Acknowledgements", bundle: .module))
  }
}
