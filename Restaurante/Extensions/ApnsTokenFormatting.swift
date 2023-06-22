/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation


extension Data {
  /// Turn token data into a string
  func formattedApnsToken() -> String {
    return self.map { data in
      String(format: "%02.2hhx", data)
    }
    .joined()
  }
}
