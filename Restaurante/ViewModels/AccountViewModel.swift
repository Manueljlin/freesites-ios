/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine


class AccountViewModel: ObservableObject {
  
  //--------------------------------------------------------------------------//
  // Internal variables
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let apiService: ApiService
  
  
  //--------------------------------------------------------------------------//
  // Published variables
  
  @Published var logged: Bool = false
  @Published var error: Swift.Error? = nil
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    apiService: ApiService
  ) {
    self.apiService = apiService
    
    // we subscribe to token changes to check if the user is logged or not
    // this is used mainly to switch between the mainview and loginview
    self.apiService.accountTokenService.tokenPublisher
      .receive(on: DispatchQueue.main) // UI only gets updated when it changes
      .sink { [weak self] token in     // on the main thread
        self?.logged = token != nil
      }
      .store(in: &self.subscriptions)
  }
  
  
  //--------------------------------------------------------------------------//
  // Error handling
  
//  enum Error: LocalizedError {
//    case missingName
//    case missingEmail
//    case missingPassword
//    case missingPhone
//    case missingToken
//
//    case wrongData
//    case connectionError
//
//    var errorDescription: String? {
//      switch self {
//      case .missingName:     return "Falta el nombre"
//      case .missingEmail:    return "Falta el correo"
//      case .missingPassword: return "Falta la contraseña"
//      case .missingPhone:    return "Falta el teléfono"
//      case .missingToken:    return "Error de sesión"
//      case .wrongData:       return "Datos incorrectos"
//      case .connectionError: return "Error de conexión"
//      }
//    }
//
//    var recoverySuggestion: String? {
//      switch self {
//      case .missingName:     return "Escribe tu nombre para continuar"
//      case .missingEmail:    return "Escribe tu correo para continuar"
//      case .missingPassword: return "Escribe tu contraseña para continuar"
//      case .missingPhone:    return "Escribe tu teléfono para continuar"
//      case .missingToken:    return "Prueba a conectarte más tarde"
//      case .wrongData:       return "¡Ups! Comprueba de nuevo tus datos"
//      case .connectionError: return "Comprueba que cuentas con conexión a internet"
//      }
//    }
//  }
  
  
  //--------------------------------------------------------------------------//
  // Actually the stuff you care about
  
  public func login(
    email: String,
    password: String
  ) {
    self.apiService.login(
      email: email,
      password: password
    )
      .sink { completion in
        if case let .failure(error) = completion {
          print("[ERROR] -- login -- \(error.localizedDescription)")
          self.error = error
        }
      } receiveValue: { token in
        print("[OK]    -- login -- Got token: \(token)")
        self.apiService.accountTokenService.setToken(token)
      }
      .store(in: &subscriptions)
  }
  
  
  public func register(
    name: String,
    email: String,
    password: String,
    phone: String
  ) {
    self.apiService.register(
      name: name,
      email: email,
      password: password,
      phone: phone
    )
    .sink { completion in
      if case let .failure(error) = completion {
        print("[ERROR] -- register -- \(error.localizedDescription)")
        self.error = error
      }
    } receiveValue: { token in
      self.apiService.accountTokenService.setToken(token)
    }
    .store(in: &self.subscriptions)
  }
  
  
  public func logout() {
    self.apiService.logout()
      .sink { completion in
        print("[INFO]  AccountViewModel -- Logout -- \(completion)")
      } receiveValue: { success in
        if success {
          self.apiService.accountTokenService.removeToken()
        }
      }
      .store(in: &self.subscriptions)
  }
  
  
  public func update(
    name: String,
    password: String,
    phone: String
  ) {
    self.apiService.update(
      name: name,
      password: password,
      phone: phone
    )
      .sink { completion in
        print(completion)
      } receiveValue: { message in
        print(message)
      }
      .store(in: &self.subscriptions)
  }
  
  
  public func deleteAccount() {
    self.apiService.deleteAccount()
      .sink { _ in } receiveValue: { deleted in
        guard deleted else { return }
        self.apiService.accountTokenService.removeToken()
      }
      .store(in: &self.subscriptions)
  }
}
