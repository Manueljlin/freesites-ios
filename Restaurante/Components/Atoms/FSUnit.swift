/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation


/// Generic units for the UI
enum FSUnit: CGFloat {
  /// Extra Small -- 2
  case xs   = 2
  
  /// Small -- 4
  case s    = 4
  
  /// Medium -- 6
  case m    = 6
  
  /// Medium large -- 8
  case ml   = 8
  
  /// Large -- 12
  case l    = 12
  
  /// Extra Large -- 14
  case xl   = 14 // corner radius
  
  /// Extra Extra Large -- 24
  case xxl  = 24
  
  /// Get horizontal size for unit
  static func side(_ unit: FSUnit) -> CGFloat {
    unit.rawValue + 6
  }
  
  /// Get vertical size for unit
  static func main(_ unit: FSUnit) -> CGFloat {
    unit.rawValue
  }
}
