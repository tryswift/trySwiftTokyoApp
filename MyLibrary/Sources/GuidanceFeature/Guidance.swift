import ComposableArchitecture
import CoreLocation
import DependencyExtra
import Foundation
@preconcurrency import MapKit
import MapKitClient
import SwiftUI

@Reducer
public struct Guidance {

  @ObservableState
  public struct State: Equatable, Sendable {
    var lines: Lines = .metroShibuya
    var route: MKRoute?
    var origin: MKMapItem?
    var originTitle: LocalizedStringKey { lines.originTitle }
    var destinationItem: MKMapItem?
    var cameraPosition: MapCameraPosition = .automatic
    var isLookAroundPresented: Bool = false
    var lookAround: MKLookAroundScene?

    var routeOrigin: CLLocationCoordinate2D? {
      guard let route = route else { return nil }
      let pointCount = route.polyline.pointCount
      var coords = [CLLocationCoordinate2D](
        repeating: kCLLocationCoordinate2DInvalid,
        count: pointCount
      )
      route.polyline.getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
      return coords.first
    }
    public init() {}
  }

  public enum Action: BindableAction, ViewAction {
    case binding(BindingAction<State>)
    case view(View)
    case initialResponse(Result<(MKMapItem, MKMapItem, MKRoute, MKLookAroundScene?)?, Error>)
    case updateResponse(Result<(MKMapItem, MKRoute, MKLookAroundScene?)?, Error>)

    public enum View {
      case onAppear
      case openMapTapped
    }
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .run { [state] send in
          await send(
            .initialResponse(
              Result {
                try await onAppear(lines: state.lines)
              }
            )
          )
        }
      case let .initialResponse(.success(response)):
        guard let response = response else { return .none }
        let route = response.2

        state.origin = response.0
        state.destinationItem = response.1
        state.route = route
        state.lookAround = response.3
        //TODO: Calculate distance from 2 CLLocation
        state.cameraPosition = .camera(
          .init(centerCoordinate: route.polyline.coordinate, distance: route.distance * 2))
        return .none

      case let .initialResponse(.failure(error)):
        print(error)
        return .none

      case let .updateResponse(.success(response)):
        guard let response = response else { return .none }
        let route = response.1
        state.origin = response.0
        state.route = route
        state.lookAround = response.2
        //TODO: Calculate distance from 2 CLLocation
        state.cameraPosition = .camera(
          .init(centerCoordinate: route.polyline.coordinate, distance: route.distance * 2))
        return .none

      case let .updateResponse(.failure(error)):
        print(error)
        return .none

      case .binding(\.lines):
        guard let destination = state.destinationItem else { return .none }
        return .run { [state] send in
          await send(
            .updateResponse(
              Result {
                try await update(with: state.lines, destination: destination)
              }
            )
          )
        }

      case .view(.openMapTapped):
        return .run { [state] _ in
          state.destinationItem?.openInMaps()
        }
      case .binding:
        return .none
      }
    }
  }
}

func onAppear(lines: Lines) async throws -> (MKMapItem, MKMapItem, MKRoute, MKLookAroundScene?)? {

  let items = try await withThrowingTaskGroup(
    of: (Int, MKMapItem?).self, returning: (MKMapItem?, MKMapItem?).self
  ) { group in
    group.addTask {
      @Dependency(MapKitClient.self) var mapKitClient
      return (0, try await mapKitClient.localSearch(lines.searchQuery, lines.region).first)
    }
    group.addTask {
      @Dependency(MapKitClient.self) var mapKitClient
      return (1, try await mapKitClient.localSearch("ベルサール渋谷ファースト", hallLocation).first)
    }
    var result: [Int: MKMapItem?] = [:]
    for try await (index, element) in group {
      result[index] = element
    }
    return (result[0]!, result[1]!)
  }
  @Dependency(MapKitClient.self) var mapKitClient
  guard let origin = items.0, let destination = items.1 else { return nil }
  guard let route = try await mapKitClient.mapRoute(origin, destination) else { return nil }
  let polylineOrigin = route.polyline.coords.first!
  guard
    let geoLocation = try await mapKitClient.reverseGeocodeLocation(
      .init(latitude: polylineOrigin.latitude, longitude: polylineOrigin.longitude)
    ).first
  else {
    return nil
  }
  guard let lookAroundScene = try await mapKitClient.lookAround(.init(placemark: geoLocation))
  else {
    return (origin, destination, route, nil)
  }
  return (origin, destination, route, lookAroundScene)
}

func update(with lines: Lines, destination: MKMapItem) async throws -> (
  MKMapItem, MKRoute, MKLookAroundScene?
)? {
  @Dependency(MapKitClient.self) var mapKitClient

  let origin = try await mapKitClient.localSearch(lines.searchQuery, lines.region).first
  guard let origin = origin else { return nil }
  guard let route = try await mapKitClient.mapRoute(origin, destination) else {
    print("[Error] Route Not found", origin, destination)
    return nil
  }
  let polylineOrigin = route.polyline.coords.first!
  guard
    let geoLocation = try await mapKitClient.reverseGeocodeLocation(
      .init(latitude: polylineOrigin.latitude, longitude: polylineOrigin.longitude)
    ).first
  else {
    print("[Error] Reverse Geocode failed", polylineOrigin)
    return nil
  }
  guard let lookAroundScene = try await mapKitClient.lookAround(.init(placemark: geoLocation))
  else {
    print("[Error] Look around scene not found", geoLocation)
    return (origin, route, nil)
  }
  return (origin, route, lookAroundScene)
}

@ViewAction(for: Guidance.self)
public struct GuidanceView: View {

  @Bindable public var store: StoreOf<Guidance>

  public init(store: StoreOf<Guidance>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      ScrollView {
        warning
          .padding()
        picker
        map
          .padding()

        Button {
          send(.openMapTapped)
        } label: {
          Text("Open Map", bundle: .module)
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
        directions
        venueInfo
          .padding()
      }
      .navigationTitle(Text("Venue", bundle: .module))
    }
    .lookAroundViewer(isPresented: $store.isLookAroundPresented, scene: $store.lookAround)
    .onAppear {
      send(.onAppear)
    }
  }

  @ViewBuilder
  var venueInfo: some View {
    VStack(alignment: .leading) {
      Text("Belle Salle Shibuya First", bundle: .module)
        .font(.title.bold())
      Text("Belle Salle Shibuya First address", bundle: .module)
    }
  }

  @ViewBuilder
  var picker: some View {
    Picker("Lines", selection: $store.lines) {
      ForEach(Lines.allCases) { line in
        Text(line.localizedKey, bundle: .module)
      }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
  }

  @ViewBuilder
  var map: some View {
    ZStack(alignment: .bottomLeading) {
      Map(position: $store.cameraPosition) {
        if let item = store.origin {
          Marker(item: item)
            .tint(store.lines.itemColor)
        }
        if let route = store.route {
          if let origin = store.routeOrigin {
            Marker(store.lines.exitName, coordinate: origin)
          }
          MapPolyline(route.polyline)
            .stroke(Color.accentColor, style: .init(lineWidth: 8))
        }
        if let item = store.destinationItem {
          Marker(item: item)
            .tint(.blue)
        }
      }
      .mapStyle(
        .standard(
          elevation: .realistic, emphasis: .automatic,
          pointsOfInterest: .including([.publicTransport]), showsTraffic: false)
      )
      .frame(minHeight: 240)
      .mapControlVisibility(.hidden)

      if store.lookAround != nil {
        LookAroundPreview(scene: $store.lookAround)
          .frame(width: 120, height: 80, alignment: .bottomLeading)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .padding()
      }
    }
  }

  @ViewBuilder
  var directions: some View {
    VStack(alignment: .leading) {
      Text("Directions", bundle: .module)
        .font(.headline)
      ForEach(store.lines.directions) { direction in
        VStack {
          HStack {
            Text("\(direction.order)")
            Text(direction.description, bundle: .module)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          Image(direction.imageName, bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 400)
        }
        .padding()
      }
    }
    .padding()

  }

  @ViewBuilder
  var warning: some View {
    VStack(alignment: .leading) {
      Label.init {
        VStack(alignment: .leading) {
          Text("Warning", bundle: .module)
            .font(.subheadline.bold())
            .foregroundStyle(Color.accentColor)
          Text(
            "Our venue is Belle Salle Shibuya FIRST, not garden. Make sure there are two belle salle hall in Shibuya.",
            bundle: .module
          )
          .font(.callout)
        }
      } icon: {
        Image(systemName: "exclamationmark.triangle.fill")
          .foregroundStyle(Color.accentColor)
      }
    }
    .padding()
    .overlay {
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.accentColor, lineWidth: 1)
    }
  }
}

var hallLocation: MKCoordinateRegion {
  .init(
    center: .init(latitude: 35.657920, longitude: 139.708854),
    span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
}

extension MapCameraPosition: @unchecked @retroactive Sendable {}

#Preview {
  GuidanceView(
    store: .init(initialState: .init()) {
      Guidance()
    })
}
