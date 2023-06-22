import Foundation
import MapKit


extension MKCoordinateRegion {

  func getDistancesInMeters() -> (
    latitudinalMeters: CLLocationDistance,
    longitudinalMeters: CLLocationDistance
  ) {
    let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    let topLeftCoordinate = CLLocationCoordinate2D(
        latitude: center.latitude + (span.latitudeDelta / 2),
        longitude: center.longitude - (span.longitudeDelta / 2)
    )
    let topLeftLocation = CLLocation(latitude: topLeftCoordinate.latitude, longitude: topLeftCoordinate.longitude)
    let distanceLat = centerLocation.distance(from: topLeftLocation) * 2
    let distanceLon = distanceLat
    
    return (distanceLat, distanceLon)
  }
}
