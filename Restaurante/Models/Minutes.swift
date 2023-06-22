/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation


enum Minutes: Int, CaseIterable, Identifiable {
  var id: Self { self }
  
  case five   = 5
  case ten    = 10
  case twenty = 20
  case thirty = 30
  
  var name: String {
    switch self {
      
    case .five:   return "En 5 min."
    case .ten:    return "En 10 min."
    case .twenty: return "En 20 min."
    case .thirty: return "En 30 min."
    }
  }
}
