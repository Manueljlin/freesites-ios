/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct SearchTimePeopleModal: View {
    
  //--------------------------------------------------------------------------//
  // Environment Values
  
  @Environment(\.dismiss) var dismiss
  
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  
  //--------------------------------------------------------------------------//
  // States
  
  @State private var selectedMinutes: Minutes = .five
  @State private var selectedPeople: Int = 1
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    FSModal("¿Cuánta gente, y a qué hora?") {
      HStack(spacing: .zero) {
        FSWheelPicker("Hora", selection: self.$restaurantViewModel.selectedTime) {
          ForEach(Minutes.allCases, id: \.id) { minute in
            FSText(
              minute.name,
              font: .lead,
              fullWidth: false
            ).tag(minute)
              .padding(.vertical, FSUnit.main(.xxl))
              .padding(.horizontal, FSUnit.side(.xxl))
          }
        }
        
        FSWheelPicker("Número de personas", selection: self.$restaurantViewModel.noPeople) {
          ForEach(1...8, id: \.self) { numPeople in
            FSText(
              "\(numPeople) pers.",
              font: .lead,
              fullWidth: false
            ).tag(numPeople)
              .padding(.vertical, FSUnit.main(.xxl))
              .padding(.horizontal, FSUnit.side(.xxl))
          }
        }
      }
      .frame(maxHeight: .infinity)
    } bottom: {
      FSButton("Confirmar", type: .primary) {
        self.dismiss()
      }
    }
  }
}

struct SearchTimePeopleModal_Previews: PreviewProvider {
  static var previews: some View {
    SearchTimePeopleModal()
  }
}
