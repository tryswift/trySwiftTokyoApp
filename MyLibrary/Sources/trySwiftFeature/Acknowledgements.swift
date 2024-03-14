import ComposableArchitecture
import Safari
import SwiftUI

@Reducer
public struct Acknowledgements {
  @ObservableState
  public struct State: Equatable {
    var packages = LicenseProvider.packages
    @Presents var safari: Safari.State?

    public init() {}
  }

  public enum Action {
    case urlTapped(URL)
    case safari(PresentationAction<Safari.Action>)
  }

  @Dependency(\.openURL) var openURL

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .urlTapped(let url):
        #if os(iOS) || os(macOS)
          state.safari = .init(url: url)
          return .none
        #elseif os(visionOS)
          return .run { _ in await openURL(url) }
        #endif
      case .safari:
        return .none
      }
    }
    .ifLet(\.$safari, action: \.safari) {
      Safari()
    }
  }
}

public struct AcknowledgementsView: View {

  @Bindable public var store: StoreOf<Acknowledgements>

  public var body: some View {
    list
      .sheet(item: $store.scope(state: \.safari, action: \.safari)) { sheetStore in
        SafariViewRepresentation(url: sheetStore.url)
          .ignoresSafeArea()
      }
  }

  @ViewBuilder
  var list: some View {
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
