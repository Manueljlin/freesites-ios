/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine
import MapKit


class RestaurantViewModel: ObservableObject {
  
  //--------------------------------------------------------------------------//
  // Internal variables
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let apiService: ApiService
  private let locationService: LocationService
  
  private var isFirstLocationUpdate = true // this is terrible :(
  
  
  //--------------------------------------------------------------------------//
  // Published variables
  
  //
  // Filters
  @Published public var onlyTopRated: Bool              = false
  @Published public var onlyWithTerrace: Bool           = false
  @Published public var onlyFavorites: Bool             = false
  
  @Published public var minAvgScore: Double             = 0
  @Published public var maxAvgPrice: Double             = 0
  @Published public var maxDistance: CLLocationDistance = 0
  
  @Published public var onlyTypes: [FoodType]           = []
  
  
  //
  // API Payload
  @Published public var noPeople: Int                   = 1
  @Published public var selectedTime: Minutes           = .five
  
  
  //
  // Map stuff
  @Published private var location = CLLocation(latitude: 0, longitude: 0)
  @Published public var locationWithRadius = MKCoordinateRegion()
  
  
  //
  // General data stuff
  @Published public private(set) var restaurants: [Restaurant] = []
  public var filteredRestaurants: [Restaurant] {
    var filtered = self.restaurants
    
    if self.onlyTypes != [] { filtered = filtered.filter { self.onlyTypes.contains($0.foodType) } }
    if self.onlyTopRated    { filtered = filtered.filter { $0.avgScore >= 4 } }
    if self.onlyWithTerrace { filtered = filtered.filter { $0.hasTerrace } }
    // TODO: vvvvv somehow filter the user's favorites. oh wow. vvvvvv
    //if self.onlyFavorites   { filtered = filtered.filter { $0. } }
    
    if self.location.coordinate.latitude != 0
    && self.location.coordinate.longitude != 0 {
      filtered = filtered.filter { restaurant in
        let restaurantLocation = restaurant.coordinates
        let distance = restaurantLocation.distance(from: self.location)
        return distance <= self.maxDistance
      }
    }
        
    filtered = filtered.filter { $0.avgScore >= self.minAvgScore }
    filtered = filtered.filter { $0.avgPrice <= self.maxAvgPrice }
    
    return filtered
  }
  @Published public var selectedRestaurantId: Int = .zero
  public var selectedRestaurant: Restaurant? {
    self.restaurants.first(where: { r in r.id == self.selectedRestaurantId })
  }
  
  @Published public private(set) var reservations: [Reservation] = []
  public var selectedReservationId: Int = .zero
  public var selectedReservation: Reservation? {
    self.reservations.first(where: { $0.id == self.selectedReservationId })
  }
  
  
  //--------------------------------------------------------------------------//
  // For when shit hits the fan:
  
  @Published var error: Error? = nil
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    apiService: ApiService,
    locationService: LocationService
  ) {
    self.apiService      = apiService
    self.locationService = locationService
    self.clearFilters()
    
    // we subscribe to token changes to check if the user is logged or not
    // this is used to remove (future, potentially) stale data
    self.apiService.accountTokenService.tokenPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] token in
        if token != nil {
          print("[INFO]  RestaurantsViewModel -- fetchRestaurants -- Trying to get restaurants")
          self?.fetchRestaurants()
          print("[INFO]  RestaurantsViewModel -- fetchRestaurants -- Trying to get reservations")
          self?.fetchReservations()
        } else {
          print("[INFO]  RestaurantsViewModel -- fetchRestaurants -- Erasing restaurants")
          self?.restaurants = []
          print("[INFO]  RestaurantsViewModel -- fetchRestaurants -- Erasing reservations")
          self?.reservations = []
        }
      }
      .store(in: &self.subscriptions)
    
    self.locationService.locationPublisher
      .sink { [weak self] location in
        guard let self,
              let location
        else { return }
        
        self.location = location
        
        if self.isFirstLocationUpdate {
          self.updateLocationWithRadius()
          self.isFirstLocationUpdate = false
        }
      }
      .store(in: &self.subscriptions)
  }
  
  
  private func fetchRestaurants() {
    self.apiService.getRestaurants()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case let .failure(error) = completion {
          print("[ERROR] RestaurantsViewModel -- fetchRestaurants -- \(error.localizedDescription)")
          self.error = error
        }
      } receiveValue: { restaurants in
        print("[OK]    RestaurantsViewModel -- fetchRestaurants -- Got all restaurants.")
        self.restaurants = restaurants
      }
      .store(in: &self.subscriptions)
  }
  
  
  //--------------------------------------------------------------------------//
  // View utils for mutating data
  
  //
  // Reset coordinate region on map when pressing (+) button
  public func updateLocationWithRadius() {
    self.locationWithRadius = MKCoordinateRegion(
      center: self.location.coordinate,
      latitudinalMeters: self.maxDistance * 2,
      longitudinalMeters: self.maxDistance * 2
    )
  }
  
  
  //
  // Toggle food type on/off as custom binding
  public func toggleFoodType(_ foodType: FoodType) {
    if let i = self.onlyTypes.firstIndex(of: foodType) {
      self.onlyTypes.remove(at: i)
    } else {
      self.onlyTypes.append(foodType)
    }
  }
  
  
  //
  // Reset all filters to the default value
  public func clearFilters() {
    self.onlyTopRated    = false
    self.onlyWithTerrace = false
    self.onlyFavorites   = false
    self.minAvgScore     = 0 // magic numbers strike again. gotta love it!
    self.maxAvgPrice     = 50
    self.maxDistance     = 1000
    self.onlyTypes       = []
  }
  
  
  
  
  //--------------------------------------------------------------------------//
  // Reservation view stuff that should really, really be its own View Model
  
  public func fetchReservations() {
    self.apiService.getReservations()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case let .failure(error) = completion {
          print("[ERROR] RestaurantsViewModel -- fetchReservations -- \(error.localizedDescription)")
          self.error = error
          print("Assuming expired token, so logging out locally. Hi-tech!")
          self.apiService.accountTokenService.removeToken()
        }
      } receiveValue: { reservations in
        print("[INFO]  RestaurantsViewModel -- fetchReservations -- Got reservations! Amount: \(reservations.count)")
        self.reservations = reservations.reversed() // shitty '''time''' sort
      }
      .store(in: &self.subscriptions)
  }
  
  public func cancelReservation(id: Int) {
    self.apiService.removeReservation(id: id)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case let .failure(error) = completion {
          print("[ERROR] RestaurantsViewModel -- cancelReservation(\(id)) -- \(error.localizedDescription)")
          self.error = error
        } else {
          self.fetchReservations()
        }
      } receiveValue: { message in
        print("[INFO] RestaurantsViewModel -- cancelReservation(\(id)) -- \(message)")
      }
      .store(in: &self.subscriptions)
  }
  
  public func postReservation() {
    let reservationTime = self.selectedTime.rawValue
    guard let reservationDate = Calendar.current.date(
      byAdding: .minute,
      value: reservationTime,
      to: Date()
    ) else {
      print("[INFO] RestaurantsViewModel -- postReservation -- Invalid reservationDate")
      return
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "Europe/Madrid") // TimeZone(secondsFromGMT: 0)
    let reservationDateStr = formatter.string(from: reservationDate)
    print("[INFO]  RestaurantsViewModel -- postReservation -- Formatted date: \(reservationDateStr)")
    
    self.apiService.postReservation(
      restaurantId: self.selectedRestaurantId,
      noPeople: self.noPeople,
      reservationDate: reservationDateStr // this is going to explode
    )
    .receive(on: DispatchQueue.main)
    .sink { completion in
      print(completion)
    } receiveValue: { id in
      self.fetchReservations()
      self.selectedReservationId = id
      print("[INFO]  RestaurantsViewModel -- postReservation -- New reservation's id: \(id)")
    }
    .store(in: &self.subscriptions)
  }
}
