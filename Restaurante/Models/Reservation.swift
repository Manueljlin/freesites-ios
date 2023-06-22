/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation


//"id": 3,
//"user_id": 4,
//"restaurant_id": 3,
//"table_id": null,
//"status": 2,
//"num_people": 3,
//"date_reservation": "2023-03-10 05:16:35",
//"user_name": "Meta Willms",
//"user_phone": "+1-724-924-6748",
//"created_at": "2023-06-05T19:47:30.000000Z",
//"updated_at": "2023-06-05T19:47:30.000000Z"

struct Reservation: Decodable, Identifiable {
  
  let id: Int
  let restaurantId: Int
  enum Status: Int, Decodable {
    /// The reservation is pending approval from the restaurant
    case pending = 0
    /// The reservation has been accepted by the restaurant
    case accepted = 1
    /// The client is currently in the restaurant
    case inRestaurant = 2
    /// The client has already eaten and left
    case completed = 3
    
    /// The reservation has been denied by the restaurant
    case restaurantDenied    = 10
    /// The reservation has been approved, then cancelled by the restaurant
    case restaurantCancelled = 11
    /// The reservation has been ignored by the restaurant, so it was automatically
    /// cancelled
    case ignored = 12
    
    var name: String {
      switch self {
      case .pending:             return "Pendiente"
      case .accepted:            return "Aceptada"
      case .inRestaurant:        return "En el restaurante"
      case .completed:           return "Completado"
        
      case .restaurantDenied:    return "Rechazado"
      case .restaurantCancelled: return "Cancelado"
      case .ignored:             return "Ignorado"
      }
    }
    
    var description: String {
      switch self {
      case .pending:             return "En pocos minutos su reserva será gestionada por el restaurante"
      case .accepted:            return "¡La reserva ha sido aceptada!"
      case .inRestaurant:        return "¡Que aproveche!"
      case .completed:           return "Ya has salido del restaurante"
        
      case .restaurantDenied:    return "La reserva ha sido rechazada por el restaurante"
      case .restaurantCancelled: return "La reserva ha sido aceptada, y posteriormente rechazada, por el restaurante"
      case .ignored:             return "La reserva ha sido automáticamente rechazada porque el restaurante no ha respondido a tiempo"
      }
    }
    
    var icon: FSIcon {
      switch self {
      case .pending:             return .time
      case .inRestaurant:        return .cutlery
      
      case .restaurantDenied:    return .cancel
      case .restaurantCancelled: return .cancel
      case .ignored:             return .cancel
        
      default:                   return .checkmark
      }
    }
  }
  /// Current reservation status
  let status: Status
  /// Number of people in reservation
  let noPeople: Int
  /// Date of reservation
  let date: String // TODO: move to native date type to be more user friendly
  
  
  //--------------------------------------------------------------------------//
  // Decodable
  
  enum CodingKeys: CodingKey {
    case id
    case restaurant_id
    case status
    case num_people
    case date_reservation
  }
  
  init(from decoder: Decoder) throws {
    let container     = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id           = try container.decode(Int.self, forKey: .id)
    self.restaurantId = try container.decode(Int.self, forKey: .restaurant_id)
    self.status       = try container.decode(Status.self, forKey: .status)
    self.noPeople     = try container.decode(Int.self, forKey: .num_people)
    self.date         = try container.decode(String.self, forKey: .date_reservation)
  }
}
