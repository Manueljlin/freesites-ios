/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct SearchView: View {
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  @State private var _showMap = false
  @State private var _showFilterView = false
  @State private var _showTimePeopleModal = false
  
  var body: some View {
    ZStack {
      SearchMapView()
        .environmentObject(self.restaurantViewModel)
        .opacity(self._showMap ? 1 : 0)
        .ignoresSafeArea()
      VStack(spacing: 0) {
        VStack(spacing: FSUnit.l.rawValue) {
          HStack(spacing: FSUnit.l.rawValue) {
            
            FSChip(icon: .filters, compact: true, action: { self.$_showFilterView.wrappedValue = true })
              .padding(.leading, FSUnit.side(.s))
            
            ScrollView(.horizontal, showsIndicators: false) { // chips
              HStack(spacing: FSUnit.m.rawValue) {
                FSChip(
                  "Mejor valorados",
                  icon: .star,
                  active: self.$restaurantViewModel.onlyTopRated
                )
                FSChip(
                  "Con terraza",
                  icon: .terrace,
                  active: self.$restaurantViewModel.onlyWithTerrace
                )
                FSChip(
                  "Favoritos",
                  icon: .like,
                  active: self.$restaurantViewModel.onlyFavorites
                )
                FSChip("Borrar filtros",  icon: .clear) {
                  self.restaurantViewModel.clearFilters()
                }
              }
              .padding(.trailing, FSUnit.side(.s))
            }
            .padding(.trailing, FSUnit.xxl.rawValue)
            .clipShape(Capsule())
            .padding(.trailing, -FSUnit.xxl.rawValue)
          }
          
          HStack(spacing: FSUnit.main(.xs)) {
            FSChip("Hora", icon: .time, type: .actionPrimary, rounded: false, fullWidth: true) {
              self._showTimePeopleModal.toggle()
            }
            FSChip("Pers.", icon: .people, type: .actionPrimary, rounded: false, fullWidth: true) {
              self._showTimePeopleModal.toggle()
            }
          }
          .clipShape(Capsule())
          .frame(maxWidth: 220) // :(
        }
        .padding(.vertical, FSUnit.main(.l))
        
        
        if self.restaurantViewModel.filteredRestaurants.count == 0 {
          VStack(alignment: .leading) {
            Spacer()
            Image(FSIcon.search.rawValue)
              .resizable()
              .scaledToFit()
              .frame(width: 96, height: 96)
            
            VStack(spacing: FSUnit.main(.xl)) {
              FSText(
                "Ningún restaurante cumple tus criterios...",
                font: .heading1
              )
              FSText("Prueba a seleccionar otros filtros.", font: .lead)
            }
            .padding(.horizontal, FSUnit.side(.l))
            Spacer()
            Spacer() // FIXME: :( :( :( this is sooo bad
          }
        } else {
          ScrollView { // restaurants list
            LazyVStack(spacing: FSUnit.main(.s)) {
              ForEach(self.restaurantViewModel.filteredRestaurants, id: \.id) { restaurant in
                NavigationLink {
                  RestaurantDetailsView(currentRestaurant: restaurant)
                    .onAppear {
                      self.restaurantViewModel.selectedRestaurantId = restaurant.id
                    }
                } label: {
                  FSCardFactory.fromRestaurant(restaurant, labels: {
                    FSLabel(restaurant.foodType.name, icon: .cutlery)
                    FSLabel(String(restaurant.avgScore), icon: .star)
                    FSLabel(String(restaurant.avgPrice), icon: .money)
                    FSLabel("a 10 km", icon: .location)
                  })
                }
              }
            }
//            .padding(.bottom, FSUnit.l.rawValue)
            .padding(.bottom, FSUnit.main(.xxl) * 4) // :(
          }
          .padding(.bottom, FSUnit.xxl.rawValue)
          .clipShape(RoundedRectangle(cornerRadius: FSUnit.xxl.rawValue, style: .continuous))
          .padding(.bottom, -FSUnit.xxl.rawValue)
          .padding(.horizontal, FSUnit.side(.s))
          .opacity(self._showMap ? 0 : 1)
        }
      }
      
      VStack {
        Spacer()
        
        HStack {
          if self._showMap {
            FSButton(icon: .currentLocation, fullWidth: false) {
              self.restaurantViewModel.updateLocationWithRadius()
            }
            .shadow(color: Color.black.opacity(0.02), radius: 0, x: 0, y: 1)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
          }
          Spacer()
          FSButton(
            self._showMap ? "Lista" : "Mapa",
            icon: self._showMap ? .list : .map,
            type: .primary,
            fullWidth: false
          ) {
            withAnimation(Animation.easeOut.speed(5)) {
              self._showMap.toggle()
            }
          }
          .shadow(color: Color.black.opacity(0.02), radius: 0, x: 0, y: 1)
          .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.horizontal, FSUnit.side(.l))
      .padding(.bottom, FSUnit.xxl.rawValue)
    }
    .sheet(isPresented: self.$_showFilterView) {
      SearchFiltersView()
        .environmentObject(self.restaurantViewModel)
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
    .sheet(isPresented: self.$_showTimePeopleModal) {
      SearchTimePeopleModal()
        .environmentObject(self.restaurantViewModel)
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
    .background(Color.primaryBg)
  }
}


struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
//    .previewLayout(.sizeThatFits)
    .frame(maxHeight: .infinity)
//    .environment(\.colorScheme, .dark)
    .previewDisplayName("Search View")
  }
}
