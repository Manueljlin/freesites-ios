/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import CoreLocation
import Combine


class GpsLocationService: NSObject, LocationService, CLLocationManagerDelegate {
  private let locationManager: CLLocationManager
  private var currentLocation = CurrentValueSubject<CLLocation?, Never>(nil)
  
  var locationPublisher: AnyPublisher<CLLocation?, Never> {
    return self.currentLocation
      .eraseToAnyPublisher()
  }
  
  override init() {
    print("------- Init. GpsLocationService...")
    self.locationManager = CLLocationManager()
    super.init()
    
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    self.locationManager.startUpdatingLocation()
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    if status == .authorizedWhenInUse {
      print("[OK]    GpsLocationService: Got permissions. Starting location requests...")
      self.locationManager.requestLocation()
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    print("[OK]    GpsLocationService: Got new location. Updating...")
    guard let newLocation = locations.last else { return }
    self.currentLocation.send(newLocation)
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print("[ERROR] GpsLocationService: Failed with error \(error.localizedDescription)")
    return
  }
}

