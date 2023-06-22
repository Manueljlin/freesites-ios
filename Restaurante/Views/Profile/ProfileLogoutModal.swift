/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ProfileLogoutModal: View {
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var accountViewModel: AccountViewModel
  
  
  //--------------------------------------------------------------------------//
  // Environment values
  
  @Environment(\.dismiss) var dismiss
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    FSModal("¿Cerrar sesión?", bottom: {
      FSButton("Sí, quiero cerrar sesión", type: .primary) {
        self.accountViewModel.logout()
        self.dismiss()
      }
    })
  }
}


//struct ProfileLogoutModal_Previews: PreviewProvider {
//  static var previews: some View {
//    ProfileLogoutModal()
//  }
//}
