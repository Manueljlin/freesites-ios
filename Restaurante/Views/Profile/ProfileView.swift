/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ProfileView: View {
  
  @EnvironmentObject var accountViewModel: AccountViewModel
  
  @State private var _showEditModal:   Bool = false
  @State private var _showLogoutModal: Bool = false
  @State private var _showOthersView:  Bool = false
  
  
  var body: some View {
    VStack {
      VStack(spacing: FSUnit.main(.xl)) {
        FSText("Perfil", font: .heading2)
          .padding(.horizontal, FSUnit.side(.xl))
      }
      .padding(.vertical, FSUnit.main(.xl))
      
      VStack {
        Spacer()
        
        FSButton("Editar perfil", icon: .profile) {
          self._showEditModal.toggle()
        }
        FSButton("Opiniones", icon: .review)
        FSButton("Favoritos", icon: .star)
        FSButton("Otros") {
          self._showOthersView.toggle()
        }
        
        Spacer()
        
        FSButton("Cerrar sesión", type: .primary) {
          self._showLogoutModal.toggle()
        }
      }
      .padding(.horizontal, FSUnit.side(.l))
      .padding(.vertical, FSUnit.main(.l))
    }
    .navigationDestination(isPresented: self.$_showOthersView) {
      ProfileOthersView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.primaryBg)
    .sheet(isPresented: self.$_showEditModal) {
      ProfileEditModal()
//        .presentationDetents(Set(stride(from: 0.1, through: 1.0, by: 0.001).map { PresentationDetent.fraction($0) }))
    }
    .sheet(isPresented: self.$_showLogoutModal) {
      ProfileLogoutModal()
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}
