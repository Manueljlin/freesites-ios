/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ReservationCancelModal: View {
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  
  //--------------------------------------------------------------------------//
  // Environment values
  
  @Environment(\.dismiss) var dismiss
  
  
  //--------------------------------------------------------------------------//
  // Props
  
  private let reservationId: Int
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(reservationId: Int) {
    self.reservationId = reservationId
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    FSModal(
      "¿Cancelar la reserva?",
      subtitle: "No se podrá deshacer esta acción",
      bottom: {
      FSButton("Sí, cancelar", type: .primary) {
        self.restaurantViewModel.cancelReservation(id: self.reservationId)
        self.dismiss()
      }
    })
  }
}
