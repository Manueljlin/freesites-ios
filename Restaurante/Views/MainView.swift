/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI
import HidableTabView


fileprivate enum FSTabViews: Int, CaseIterable {
  case searchView
  case reservationView
  case profileView
  
  var name: String {
    switch self {
    case .searchView:      return "Buscar"
    case .reservationView: return "Reservas"
    case .profileView:     return "Perfil"
    }
  }
  
  var regularIcon: FSIcon {
    switch self {
    case .searchView:      return .search
    case .reservationView: return .table
    case .profileView:     return .profile
    }
  }
  
  var activeIcon: FSIcon {
    switch self {
    case .searchView:      return .searchFilled
    case .reservationView: return .tableFilled
    case .profileView:     return .profileFilled
    }
  }
}


struct MainView: View {
  
  @EnvironmentObject var sharedRestaurantViewModel: RestaurantViewModel
  @EnvironmentObject var sharedAccountViewModel:    AccountViewModel
  
  @State var selectedView: Int = 0
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    NavigationStack {
      VStack(spacing: .zero) {
        TabView(selection: self.$selectedView) {
          SearchView()
            .hideTabBar()
            .tag(FSTabViews.searchView.rawValue)
          
          ReservationView()
            .hideTabBar()
            .tag(FSTabViews.reservationView.rawValue)
          
          ProfileView()
            .hideTabBar()
            .environmentObject(self.sharedAccountViewModel)
            .tag(FSTabViews.profileView.rawValue)
        }
        HStack(spacing: .zero) {
          ForEach(FSTabViews.allCases, id: \.rawValue) { tab in
            FSTabItem(tab.name, regularIcon: tab.regularIcon, activeIcon: tab.activeIcon, active: Binding(
              get: { self.selectedView == tab.rawValue },
              set: { _ in self.selectedView = tab.rawValue }
            ))
          }
        }
        .background(Color.secondaryBg)
      }
    }
  }
}


struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
