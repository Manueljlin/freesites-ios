/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import MapKit


/*
{
   [x] -- "id": 1,
   [-] -- "user_id": 3,
   [x] -- "name": "Restaurante La Broche",
   [x] -- "phone": "+34953811000",
   [x] -- "address": "C. Orquídea, 36, 23700 Linares, Jaén",
   [x] -- "city": "Linares",
   [x] -- "terrace": 0,
   [x] -- "score": 4,
   [x] -- "avg_price": 25,
   [x] -- "type_food": "Pescados y Marisco",
   [x] -- "url": "https://consolepsp.com/restaurante-la-broche",
   [x] -- "img_profile": "", // absolute image url
   [x] -- "img_gallery": "", // encoded array of absolute image url
   [x] -- "description": "Un restaurante familiar con platos de pescadosy marisco buenisimos.",
   [x] -- "latitude": 38.09804121954383,
   [x] -- "longitude": -3.6237226800114724,
   [x] -- "status": 1,
   [-] -- "created_at": "2023-05-21T08:00:11.000000Z",
   [-] -- "updated_at": "2023-05-21T08:03:58.000000Z"
},
*/

struct Restaurant: Decodable, Identifiable {
  
  let id: Int
  let name: String
  let phone: String
  let address: String
  let city: String
  let hasTerrace: Bool
  let avgScore: Double
  let avgPrice: Double
  let foodType: FoodType
  let url: URL?
  let profileImage: URL?
  let imageGallery: [URL]?
  let description: String
  let coordinates: CLLocation   // latitude, longitude
  enum Status: Int, Decodable {
    case closed                 // 0
    case openWithFreeSpots      // 1
    case openWithoutFreeSpots   // 2
    
    var name: String {
      switch self {
      case .closed:               return "Cerrado"
      case .openWithFreeSpots:    return "Abierto, con sitio disponible"
      case .openWithoutFreeSpots: return "Abierto, pero todo ocupado"
      }
    }
  }
  let status: Status
  
  
  //--------------------------------------------------------------------------//
  // Decodable
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case phone
    case address
    case city
    case terrace
    case score
    case avg_price
    case type_food
    case url
    case img_profile
    case img_gallery
    case description
    case latitude
    case longitude
    case status
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id               = try container.decode(Int.self,      forKey: .id)
    self.name             = try container.decode(String.self,   forKey: .name)
    self.phone            = try container.decode(String.self,   forKey: .phone)
    self.address          = try container.decode(String.self,   forKey: .address)
    self.city             = try container.decode(String.self,   forKey: .city)
    
    let terraceNumber     = try container.decode(Int.self,     forKey: .terrace) // :(
    self.hasTerrace       = terraceNumber == 1
    
    self.avgScore         = try container.decode(Double.self,   forKey: .score)
    self.avgPrice         = try container.decode(Double.self,   forKey: .avg_price)
    self.foodType         = try container.decode(FoodType.self, forKey: .type_food)
    let url               = try container.decode(String?.self, forKey: .url)
    if let url {
      self.url = URL(string: url)
    } else {
      self.url = nil
    }
    self.profileImage     = try container.decode(URL?.self,   forKey: .img_profile)
    
    if let imageGalleryStr = try container.decodeIfPresent(String.self, forKey: .img_gallery) {
      let data = Data(imageGalleryStr.utf8)
      self.imageGallery = try JSONDecoder().decode([URL].self, from: data)
    } else {
      self.imageGallery = []
    }
    
    self.description      = try container.decode(String.self,    forKey: .description)
    self.coordinates      = try CLLocation(
        latitude:  container.decode(Double.self, forKey: .latitude),
        longitude: container.decode(Double.self, forKey: .longitude)
    )
    self.status = try container.decode(Status.self, forKey: .status)
  }
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    id: Int,
    name: String,
    phone: String,
    address: String,
    city: String,
    hasTerrace: Bool,
    avgScore: Double,
    avgPrice: Double,
    foodType: FoodType,
    url: URL?,
    profileImage: URL?,
    imageGallery: [URL]?,
    description: String,
    coordinates: CLLocation,
    status: Status
  ) {
    self.id               = id
    self.name             = name
    self.phone            = phone
    self.address          = address
    self.city             = city
    self.hasTerrace       = hasTerrace
    self.avgScore         = avgScore
    self.avgPrice         = avgPrice
    self.foodType         = foodType
    self.url              = url
    self.profileImage     = profileImage
    self.imageGallery     = imageGallery
    self.description      = description
    self.coordinates      = coordinates
    self.status           = status
  }
  
  
  //--------------------------------------------------------------------------//
  // Examples
  
  // TODO: Update examples arr
//  static let examples: [Restaurant] = [
//    Restaurant(
//      id: 1,
//      name: "Restaurante La Broche",
//      phone: "+34953811000",
//      address: "C. Orquídea, 36",
//      city: "Linares",
//      hasTerrace: false,
//      avgScore: 4.0,
//      avgPrice: 25,
//      foodType: .fishAndSeafood,
//      url: URL(string: "https://consolepsp.com/restaurante-la-broche"),
//      profileImage: "/ruta/imagen1.jpg",
//      imageGalleryPath: "/ruta/imagenes/",
//      description: "Un restaurante familiar con platos de pescados y marisco buenísimos",
//      coordinates: CLLocation(
//        latitude: 38.09804121954383,
//        longitude: -3.6237226800114724
//      ),
//      status: .openWithFreeSpots
//    ),
//    Restaurant(
//      id: 2,
//      name: "Restaurante Los Sentidos",
//      phone: "+34953651072",
//      address: "C. Doctor, 13",
//      city: "Linares",
//      hasTerrace: true,
//      avgScore: 4.8,
//      avgPrice: 35,
//      foodType: .international,
//      url: URL(string: "https://www.lossentidos.net/"),
//      profileImage: "/ruta/imagen2.jpg",
//      imageGalleryPath: "/ruta/imagenes/",
//      description: "Alta cocina internacional en antigua casa renovada en la que la piedra original convive con un aire minimalista y oriental.",
//      coordinates: CLLocation(
//        latitude: 38.09191774610039,
//        longitude: -3.6296337846795628
//      ),
//      status: .openWithoutFreeSpots
//    ),
//    Restaurant(
//      id: 3,
//      name: "Café Mañas Bar Los Jamones 2",
//      phone: "+34953010937",
//      address: "C. Santiago, 37",
//      city: "Linares",
//      hasTerrace: true,
//      avgScore: 4.4,
//      avgPrice: 12,
//      foodType: .mediterranean,
//      url: URL(string: "https://www.barlosjamones.com/"),
//      profileImage: "/ruta/imagen3.jpg",
//      imageGalleryPath: "/ruta/imagenes/",
//      description: "Restaurante especializado en cocina mediterránea con productos frescos de la región",
//      coordinates: CLLocation(
//        latitude: 38.09191774610039,
//        longitude: -3.6296337846795628
//      ),
//      status: .openWithoutFreeSpots
//    ),
//    Restaurant(
//      id: 4,
//      name: "Bar PonDos",
//      phone: "+34608329980",
//      address: "Pl. Aníbal e Himilce, 4",
//      city: "Linares",
//      hasTerrace: true,
//      avgScore: 4.3,
//      avgPrice: 15,
//      foodType: .mediterranean,
//      url: URL(string: "https://www.pondos.es"),
//      profileImage: "/ruta/imagen4.jpg",
//      imageGalleryPath: "/ruta/imagenes/",
//      description: "Restaurante especializado en cocina mediterránea",
//      coordinates: CLLocation(
//        latitude: 38.092481377799324,
//        longitude: -3.639846793829775
//      ),
//      status: .openWithoutFreeSpots
//    ),
//    Restaurant(
//      id: 5,
//      name: "Restaurante Canela en Rama",
//      phone: "+34953602532",
//      address: "C. República Argentina, 12",
//      city: "Linares",
//      hasTerrace: true,
//      avgScore: 4.3,
//      avgPrice: 15,
//      foodType: .mediterranean,
//      url: URL(string: "https://www.pondos.es"),
//      profileImage: "/ruta/imagen4.jpg",
//      imageGalleryPath: "/ruta/imagenes/",
//      description: "Restaurante especializado en cocina mediterránea",
//      coordinates: CLLocation(
//        latitude: 38.095987470656119,
//        longitude: -3.6314829314093431
//      ),
//      status: .closed
//    ),
//  ]
}
