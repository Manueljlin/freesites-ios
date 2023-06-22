/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ProfileOthersView: View {
  
  @Environment(\.dismiss) var dismiss
  
  @State private var _showDeleteAccountModal:  Bool = false
  
  
  var body: some View {
    VStack {
      Spacer()
      FSButton("Política de privacidad")
      FSButton("Condiciones de uso")
      FSButton("Eliminar cuenta") {
        self._showDeleteAccountModal.toggle()
      }
      Spacer()
    }
    .padding(.horizontal, FSUnit.side(.l))
    .padding(.vertical, FSUnit.main(.l))
    .background(Color.primaryBg)
    .sheet(isPresented: self.$_showDeleteAccountModal) {
      ProfileDeleteAccountConfirmationModal()
    }
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        FSChip("Atrás", icon: .back) {
          self.dismiss()
        }
      }
      ToolbarItem(placement: .principal) {
        FSText("Otros", font: .lead, fullWidth: false)
      }
    }
  }
}

struct ProfileOthersView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileOthersView()
    }
}
