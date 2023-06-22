/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine


protocol ApiService {
  
  var accountTokenService: AccountTokenService { get }
  
  //--------------------------------------------------------------------------//
  // User auth
  
  func login(
    email: String,
    password: String
    //apnsToken: String
  ) -> AnyPublisher<String, Error> // Token|Error
  
  func register(
    name: String,
    email: String,
    password: String,
    phone: String
    //apnsToken: String
  ) -> AnyPublisher<String, Error> // Token|Error
  
  func update(
    name: String,
    password: String,
    phone: String
  ) -> AnyPublisher<String, Error> // Message|Error
  
  func logout() -> AnyPublisher<Bool, Error>
  
  func deleteAccount() -> AnyPublisher<Bool, Error>
  
  
  //--------------------------------------------------------------------------//
  // Restaurants
  
  func getRestaurants() -> AnyPublisher<[Restaurant], Error>
  
  // TODO: get restaurants in coords + radius
  // https://medium.com/@keshavx11/set-mapview-zoom-within-radius-of-a-location-coordinate-in-swift-cf7f58e67edf
//  func getRestaurantsInRadius(
//    location: MKCoordinateRegion, // MKCoordinateRegionMakeWithDistance(location, diameter, diameter)
//    withToken token: String
//  )
  
  
  //--------------------------------------------------------------------------//
  // Reservations
  
  func getReservations() -> AnyPublisher<[Reservation], Error>
  
  func removeReservation(id: Int) -> AnyPublisher<String, Error>
  
  func postReservation(
    restaurantId: Int,
    noPeople: Int,
    reservationDate: String
  ) -> AnyPublisher<Int, Error> // Reservation ID|Error
}
