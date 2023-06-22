/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation


enum FoodType: String, Decodable, CaseIterableDefaultsLast {
  
  case grilledMeat     = "Asador de carne"
  case asian           = "Asiática"
  case italian         = "Italiana"
  case fastFood        = "Comida rápida"
  case mediterranean   = "Mediterránea"
  case mexican         = "Mexicana"
  case vegetarian      = "Vegetariana/vegana"
  case international   = "Internacional"
  case traditional     = "Español tradicional"
  case fishAndSeafood  = "Mariscos y pescados"
  case tapasAndPinchos = "Tapas y pinchos"
  case unknown
  
  var name: String { // just in case I have to override one or something
    switch self {
    case .grilledMeat:     return self.rawValue
    case .asian:           return self.rawValue
    case .italian:         return self.rawValue
    case .fastFood:        return self.rawValue
    case .mediterranean:   return self.rawValue
    case .mexican:         return self.rawValue
    case .vegetarian:      return self.rawValue
    case .international:   return self.rawValue
    case .traditional:     return self.rawValue
    case .fishAndSeafood:  return self.rawValue
    case .tapasAndPinchos: return self.rawValue
    case .unknown:         return "Otros"
    }
  }
}
