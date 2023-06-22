/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ReservationView: View {
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  @State private var _showPending: Bool = true
  
  @State private var _showCancelModal: Bool = false
  @State private var _reservationId: Int = .zero
  
  @Environment(\.openURL) private var openURL
  
  var body: some View {
    VStack(spacing: .zero) {
      VStack(spacing: FSUnit.main(.xl)) {
        FSText("Reservas", font: .heading2)
          .padding(.horizontal, FSUnit.side(.xl))
        
        HStack(spacing: FSUnit.main(.m)) {
          FSChip("Pendientes", fullWidth: true, active: Binding(
            get: { self.$_showPending.wrappedValue },
            set: { _ in self.$_showPending.wrappedValue = true }
          ))
          FSChip("Historial", fullWidth: true, active: Binding(
            get: { !self.$_showPending.wrappedValue },
            set: { _ in self.$_showPending.wrappedValue = false }
          ))
        }
        .padding(.horizontal, FSUnit.side(.s))
      }
      .padding(.vertical, FSUnit.main(.xl))
      
      
      ScrollView {
        LazyVStack(spacing: FSUnit.main(.s)) {
          if self._showPending {
            ForEach(self.restaurantViewModel.reservations, id: \.id) { reservation in
              if reservation.status == Reservation.Status.pending {
                if let restaurant = self.restaurantViewModel.restaurants
                  .first(where: { $0.id == reservation.restaurantId }) {
                  FSCardFactory.fromRestaurant(restaurant) {
                    FSLabel(reservation.status.name, icon: reservation.status.icon)
                    FSLabel(reservation.date.formatRelative(), icon: .calendar)
                    FSLabel("\(reservation.noPeople) persona/s", icon: .people)
                  } bottom: {
                    HStack(spacing: FSUnit.main(.m)) {
                      FSButton("Llamar", icon: .phone) {
                        guard let num = URL(string: "tel://" + restaurant.phone) else {
                          print("rip")
                          return
                        }
                        openURL(num)
                      }
                      FSButton("Cancelar", icon: .cancel) {
                        self._reservationId = reservation.id
                        self._showCancelModal.toggle()
                      }
                    }
                  }
                }
              }
            }
          } else {
            ForEach(self.restaurantViewModel.reservations, id: \.id) { reservation in
              if reservation.status != Reservation.Status.pending {
                if let restaurant = self.restaurantViewModel.restaurants
                    .first(where: { $0.id == reservation.restaurantId }) {
                  FSCardFactory.fromRestaurant(restaurant) {
                    FSLabel(reservation.status.name, icon: reservation.status.icon)
                    FSLabel(reservation.date.formatRelative(), icon: .calendar)
                    FSLabel("\(reservation.noPeople) persona/s", icon: .people)
                  } bottom: {
                    HStack(spacing: FSUnit.main(.m)) {
                      FSButton("Compartir", icon: .share)
                      FSButton("Opinar", icon: .review)
                    }
                  }
                }
              }
            }
          }
        }
        .padding(.bottom, FSUnit.l.rawValue)
      }
      .sheet(isPresented: self.$_showCancelModal) {
        ReservationCancelModal(reservationId: self._reservationId)
      }
      .padding(.bottom, FSUnit.xxl.rawValue)
      .clipShape(RoundedRectangle(cornerRadius: FSUnit.xxl.rawValue, style: .continuous))
      .padding(.bottom, -FSUnit.xxl.rawValue)
      .padding(.horizontal, FSUnit.side(.s))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.primaryBg)
//      .navigationBarBackButtonHidden(true)
//      .toolbar(.visible)
//      .toolbar {
//        ToolbarItem(placement: .navigationBarLeading) {
//          FSChip("Atrás", icon: .back)
//        }
//        ToolbarItem(placement: .navigation) {
//          FSText("Perfil", font: .heading2, alignment: .center, fullWidth: false)
//        }
//      }
  }
}

struct ReservationView_Previews: PreviewProvider {
  static var previews: some View {
    ReservationView()
  }
}
