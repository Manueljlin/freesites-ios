/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ProfileDeleteAccountConfirmationModal: View {
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var accountViewModel: AccountViewModel
  
  
  //--------------------------------------------------------------------------//
  // Environment values
  
  @Environment(\.dismiss) var dismiss
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    FSModal(
      "¿Borrar tu cuenta?",
      subtitle: "No se podrá deshacer esta acción",
      type: .warning,
      bottom: {
        FSButton("Sí, estoy seguro") {
          self.accountViewModel.deleteAccount()
          self.dismiss()
        }
      }
    )
  }
}
