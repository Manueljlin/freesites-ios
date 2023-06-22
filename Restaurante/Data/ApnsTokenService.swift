/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine


class ApnsTokenService {
  private let tokenService: ObservableStorage<String>
  
  public var tokenPublisher: AnyPublisher<String?, Never> {
    return self.tokenService.valuePublisher
  }
  
  
  init(tokenKey: String) {
    print("------- Init. ApnsTokenService...")
    self.tokenService = ObservableStorage<String>(key: tokenKey)
    self.getToken()
  }
  
  
  public func setToken(_ token: Data) {
    print("[INFO]  ApnsTokenService: Got new token! -- \(token.formattedApnsToken())")
    self.tokenService.setValue(token.formattedApnsToken())
  }
  
  private func getToken() {
    self.tokenService.getValue()
  }
  
  public func removeToken() {
    self.tokenService.removeValue()
  }
}
