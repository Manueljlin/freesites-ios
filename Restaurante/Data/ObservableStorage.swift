/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import Foundation
import Combine


struct ObservableStorage<T> {
  private let key: String
  private let subject = CurrentValueSubject<T?, Never>(nil)
  
  // ensure thread safety
  private let queue = DispatchQueue(
    label: "es.estech.grupodos.restaurante", // ensure uniqueness
    qos: .userInitiated // quality of service/priority
  )
  
  var valuePublisher: AnyPublisher<T?, Never> {
    return subject
      .eraseToAnyPublisher()
  }
  
  init(key: String) {
    self.key = key
    self.getValue()
  }
  
  func setValue(_ value: T?) {
    self.queue.async {
      UserDefaults.standard.set(value, forKey: self.key)
      subject.send(value)
    }
  }
  
  func getValue() {
    self.queue.async {
      let value = UserDefaults.standard.object(forKey: self.key) as? T
      subject.send(value)
    }
  }
  
  func removeValue() {
    self.queue.async {
      UserDefaults.standard.removeObject(forKey: self.key)
      subject.send(nil)
    }
  }
}
