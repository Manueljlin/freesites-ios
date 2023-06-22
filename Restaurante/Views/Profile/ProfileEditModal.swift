/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ProfileEditModal: View {
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var accountViewModel: AccountViewModel
  
  
  //--------------------------------------------------------------------------//
  // Environment values
  
  @Environment(\.dismiss) var dismiss
  
  
  //--------------------------------------------------------------------------//
  // State
  
  @State private var name:     String = ""
  @State private var phone:    String = ""
  @State private var password: String = ""
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    FSModal(
      "Editar perfil",
      subtitle: "Puedes cambiar los datos de tu perfil para mantenerlos actualizados",
      detents: [.medium, .large]
    ) {
      VStack(spacing: FSUnit.main(.ml)) {
        Spacer()
        FSTextField("Nombre", icon: .profile, text: self.$name)
        FSTextField("Teléfono", icon: .phone, text: self.$phone, keyboardType: .phonePad)
        FSTextField("Contraseña", icon: .lock, type: .password, text: self.$password, keyboardType: .asciiCapable)
        Spacer()
      }
    } bottom: {
      FSButton("Guardar cambios", type: .primary) {
        self.accountViewModel.update(
          name: self.name,
          password: self.password,
          phone: self.phone
        )
        self.dismiss()
      }
    }
  }
}
