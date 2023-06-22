/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct LoginPasswordResetModal: View {
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var accountViewModel: AccountViewModel
  
  
  //--------------------------------------------------------------------------//
  // State
  
  @State private var email: String = ""
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    FSModal(
      "¿Problemas iniciando sesión?",
      subtitle: "Reestablece tu contraseña introduciendo tu correo"
    ) {
      FSTextField("Correo", icon: .mail, text: self.$email)
    } bottom: {
      FSButton("Enviar", type: .primary) {
        
      }
    }
  }
}

//
//struct LoginPasswordResetModal_Previews: PreviewProvider {
//  static var previews: some View {
//    LoginPasswordResetModal()
//  }
//}
