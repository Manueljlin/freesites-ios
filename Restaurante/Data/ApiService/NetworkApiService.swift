/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine


class NetworkApiService: ApiService {
  
  //--------------------------------------------------------------------------//
  // Internal variables
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let baseUrl: String
  private var currentAccountToken: String?
  private var currentApnsToken: String?
  
  
  //--------------------------------------------------------------------------//
  // Public variables
  
  let accountTokenService: AccountTokenService
  let apnsTokenService: ApnsTokenService
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    baseUrl: String,
    accountTokenService: AccountTokenService,
    apnsTokenService: ApnsTokenService
  ) {
    self.baseUrl = baseUrl
    self.accountTokenService = accountTokenService
    self.apnsTokenService    = apnsTokenService
    
    //
    // we subscribe to both token's changes to give the methods the tokens they need
    self.accountTokenService.tokenPublisher
      .sink { [weak self] token in
        self?.currentAccountToken = token
      }
      .store(in: &self.subscriptions)
    
    self.apnsTokenService.tokenPublisher
      .sink { [weak self] token in
        self?.currentApnsToken = token
      }
      .store(in: &self.subscriptions)
  }
  
  
  
  
  //--------------------------------------------------------------------------//
  // User account mgmt
  
  //
  // Log in with existing account
  public func login(
    email: String,
    password: String
  ) -> AnyPublisher<String, Error> { // returns token or error
    
    guard let url = URL(string: self.baseUrl + "/login") else {
      let error = URLError(.badURL)
      
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    let params: [String: Any] = [
      "email":    email,
      "password": password,
      "device_type": 1, // tell backend we're logging in from iOS
      "token_notification": self.currentApnsToken as Any // string|nil
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    
    do {
      let params = try JSONSerialization.data(
        withJSONObject: params,
        options: [.fragmentsAllowed, .prettyPrinted]
      )
      print(NSString(data: params, encoding: String.Encoding.utf8.rawValue)!)
      request.httpBody = params
    } catch {
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        print("in")
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          let code = URLError.Code(rawValue: httpResponse.statusCode)
          throw URLError(code)
        }
        
        return data
      }
//      .decode(type: [String: Any].self, decoder: JSONDecoder())
      .tryMap { data in
        guard let decodedResponse = try JSONSerialization
                .jsonObject(with: data) as? [String: Any],
              let token = decodedResponse["token"] as? String else {
          throw URLError(.badServerResponse)
        }
        
        return token
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  
  //
  // Register new account
  public func register(
    name: String,
    email: String,
    password: String,
    phone: String
  ) -> AnyPublisher<String, Error> {
    
    guard let url = URL(string: self.baseUrl + "/register") else {
      let error = URLError(.badURL)
      
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    let params: [String: Any] = [
      "name":     name,
      "email":    email,
      "password": password,
      "phone":    phone,
      "role":     10, // I believe this isn't necessary anymore
      "device_type": 1, // tell backend we're logging in from iOS
      "token_notification": self.currentApnsToken as Any // string|nil
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    
    do {
      let params = try JSONSerialization.data(
        withJSONObject: params,
        options: [.fragmentsAllowed, .prettyPrinted]
      )
      print(NSString(data: params, encoding: String.Encoding.utf8.rawValue)!)
      request.httpBody = params
    } catch {
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        print(data)
        
        guard 200...299 ~= httpResponse.statusCode else {
          let code = URLError.Code(rawValue: httpResponse.statusCode)
          throw URLError(code)
        }
        
        return data
      }
      .tryMap { data in
        let jsonObject = try JSONSerialization
          .jsonObject(with: data, options: [])
        
        guard let json = jsonObject as? [String: Any] else { // manually decode json with any
          throw URLError(.badServerResponse)
        }
        
        return json
      }
      .tryMap { json in
        guard let token = json["token"] as? String else {
          throw URLError(.badServerResponse)
        }
        
        return token
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  
  //
  // Update current user's account details
  public func update(
    name: String,
    password: String,
    phone: String
  ) -> AnyPublisher<String, Error> {
    
    guard let token = self.currentAccountToken else {
      return Fail(error: URLError(.userAuthenticationRequired))
        .eraseToAnyPublisher()
    }
    
    guard let url = URL(string: self.baseUrl + "/update_user") else {
      return Fail(error: URLError(.badURL))
        .eraseToAnyPublisher()
    }

    let params: [String: Any] = [
      "name": name,
      "password": password,
      "phone": phone
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    

    do {
      let params = try JSONSerialization.data(
        withJSONObject: params,
        options: [.fragmentsAllowed, .prettyPrinted]
      )
      print(NSString(data: params, encoding: String.Encoding.utf8.rawValue)!)
      request.httpBody = params
    } catch {
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
        }
        
        return data
      }
      .decode(type: [String: String?].self, decoder: JSONDecoder())
      .tryMap { json in
        guard let message = json["message"] else {
          throw URLError(.badServerResponse)
        }
        print(message!)
        return message! // it will always return a message, the null part is from the user which we're ignoring
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  public func logout() -> AnyPublisher<Bool, Error> {
    guard let url = URL(string: self.baseUrl + "/logout") else {
      let error = URLError(.badURL)
      
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    let params: [String: Any] = [
      // why does it need this? we're already through the middleware my guy,
      // you already know which user I am :p
      "token": self.currentAccountToken as Any // string|nil
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    
    do {
      let params = try JSONSerialization.data(
        withJSONObject: params,
        options: [.fragmentsAllowed, .prettyPrinted]
      )
      print(NSString(data: params, encoding: String.Encoding.utf8.rawValue)!)
      request.httpBody = params
    } catch {
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          let code = URLError.Code(rawValue: httpResponse.statusCode)
          throw URLError(code)
        }
        
        return data
      }
      .tryMap { data in
        let jsonObject = try JSONSerialization
          .jsonObject(with: data, options: [])
        
        guard let json = jsonObject as? [String: Any] else { // manually decode json with any
          throw URLError(.badServerResponse)
        }
        
        return json
      }
      .tryMap { json in
        guard let success = json["success"] as? Bool else {
          throw URLError(.badServerResponse)
        }
        
        return success
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  
  //
  // Delete the account from the app, for some reason
  public func deleteAccount() -> AnyPublisher<Bool, Error> {
    
    guard let token = self.currentAccountToken else {
      return Fail(error: URLError(.userAuthenticationRequired))
        .eraseToAnyPublisher()
    }
    
    guard let url = URL(string: self.baseUrl + "/delete_user") else {
      return Fail(error: URLError(.badURL))
        .eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
        }
        
        return data
      }
      .decode(type: [String: String?].self, decoder: JSONDecoder())
      .tryMap { json in
        guard let message = json["message"] else {
          throw URLError(.badServerResponse)
        }
        return true
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  
  
  
  //--------------------------------------------------------------------------//
  // Restaurants
  
  public func getRestaurants() -> AnyPublisher<[Restaurant], Error> {
    
    guard let token = self.currentAccountToken else {
      let error = URLError(.userAuthenticationRequired)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    guard let url = URL(string: self.baseUrl + "/get_all_restaurants") else {
      let error = URLError(.badURL)
      
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    // FIXME: ^^^^^ this is frowned upon by apple, but I don't know what to do otherwise?
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          let code = URLError.Code(rawValue: httpResponse.statusCode)
          throw URLError(code)
        }
        
        return data
      }
      .decode(type: [Restaurant].self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
    
  
  
  
  //--------------------------------------------------------------------------//
  // Reservations
  
  public func getReservations() -> AnyPublisher<[Reservation], Error> {
    
    guard let token = self.currentAccountToken else {
      let error = URLError(.userAuthenticationRequired)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    guard let url = URL(string: self.baseUrl + "/reservations_user") else {
      let error = URLError(.badURL)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          let code = URLError.Code(rawValue: httpResponse.statusCode)
          throw URLError(code)
        }
        
        return data
      }
      .decode(type: [Reservation].self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main) // redundant?
      .eraseToAnyPublisher()
  }
  
  
  public func removeReservation(id: Int) -> AnyPublisher<String, Error> {
    
    guard let token = self.currentAccountToken else {
      let error = URLError(.userAuthenticationRequired)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    guard let url = URL(string: self.baseUrl + "/delete_reservation/\(id)") else {
      let error = URLError(.badURL)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
        }
        
        return data
      }
      .decode(type: [String: String?].self, decoder: JSONDecoder())
      .tryMap { json in
        guard let message = json["message"] else {
          throw URLError(.badServerResponse)
        }
        return message! // it'll always return a message
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  
  public func postReservation(
    restaurantId: Int,
    noPeople: Int,
    reservationDate: String
  ) -> AnyPublisher<Int, Error> {
    guard let token = self.currentAccountToken else {
      let error = URLError(.userAuthenticationRequired)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    guard let url = URL(string: self.baseUrl + "/reservation") else {
      let error = URLError(.badURL)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let params: [String: Any] = [
      "restaurant_id": restaurantId,
      "num_people": noPeople,
      "date_reservation": reservationDate
    ]
    
    do {
      let params = try JSONSerialization.data(
        withJSONObject: params,
        options: [.fragmentsAllowed, .prettyPrinted]
      )
      print(NSString(data: params, encoding: String.Encoding.utf8.rawValue)!)
      request.httpBody = params
    } catch {
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.unknown)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
          throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
        }
        
        return data
      }
      .tryMap { data in
        let jsonObject = try JSONSerialization
          .jsonObject(with: data, options: [])
        
        guard let json = jsonObject as? [String: Any] else { // manually decode json with any
          throw URLError(.badServerResponse)
        }
        
        return json
      }
      .tryMap { json in
        guard let _ = json["message"] as? String else {
          throw URLError(.badServerResponse)
        }
        guard let id = json["id"] as? Int else {
          throw URLError(.badServerResponse)
        }
        
        return id
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
