/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ReservationConfirmationModal: View {
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  @Environment(\.dismiss) var dismiss
  
  @Binding private var confirm: Bool
  
  init(toggleOnConfirm confirm: Binding<Bool>) {
    self._confirm = confirm
  }
  
  var body: some View {
    FSModal(
      "¿Deseas confirmar la reserva?"
    ) {
      VStack(spacing: FSUnit.main(.xl)) {
        FSText(
          self.restaurantViewModel.selectedRestaurant?.name ?? "",
          font: .heading2,
          alignment: .center,
          multilineAlignment: .center
        )
        
        HStack(spacing: .zero) {
          FSChip("Hoy, \(self.restaurantViewModel.selectedTime.name)", icon: .calendar, rounded: false)
          FSChip("\(self.restaurantViewModel.noPeople)", icon: .people, rounded: false)
        }
        .clipShape(Capsule())
      }
      .padding(.horizontal, FSUnit.side(.xxl))
      .padding(.vertical, FSUnit.main(.xxl))
      .background(Color.primaryBg)
      .clipShape(RoundedRectangle(cornerRadius: FSUnit.main(.xl), style: .continuous))
    } bottom: {
      FSButton("Confirmar reserva", type: .primary) {
        self.confirm.toggle()
        self.restaurantViewModel.postReservation()
        self.dismiss()
      }
    }
  }
}


//struct ReservationConfirmationModal_Previews: PreviewProvider {
//  static var previews: some View {
//    ReservationConfirmationModal(
//      toggleOnConfirm: Binding(
//        get: <#T##() -> _#>,
//        set: <#T##(_) -> Void#>
//      )
//    )
//  }
//}
