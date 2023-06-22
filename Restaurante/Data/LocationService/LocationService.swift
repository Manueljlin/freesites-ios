/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine
import CoreLocation


protocol LocationService {
  var locationPublisher: AnyPublisher<CLLocation?, Never> { get }
}
