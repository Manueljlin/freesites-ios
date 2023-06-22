/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine


// I'm fully aware that storing it in UserDefaults sucks, but I don't want to
// deal with using `Security` directly, at least right now. MVP, mate.
class AccountTokenService {
  private let tokenService: ObservableStorage<String>
  
  public var tokenPublisher: AnyPublisher<String?, Never> {
    return self.tokenService.valuePublisher
  }
  
  
  init(tokenKey: String) {
    print("------- Init. AccountTokenService...")
    self.tokenService = ObservableStorage<String>(key: tokenKey)
    self.getToken()
  }
  
  
  public func setToken(_ token: String) {
    self.tokenService.setValue(token)
  }
  
  private func getToken() {
    self.tokenService.getValue()
  }
  
  public func removeToken() {
    self.tokenService.removeValue()
  }
}
