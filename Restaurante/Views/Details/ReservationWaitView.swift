/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct ReservationWaitView: View {
  
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  var body: some View {
    VStack(spacing: FSUnit.main(.xxl)) {
      Spacer()
      
      if let reservation = self.restaurantViewModel.selectedReservation,
         let restaurant  = self.restaurantViewModel.restaurants.first(where: { $0.id == reservation.restaurantId }) {
        VStack(alignment: .center, spacing: FSUnit.main(.l)) {
          Image(FSIcon.get(reservation.status.icon))
            .resizable()
            .scaledToFit()
            .frame(width: 96, height: 96)
            .foregroundColor(Color.onBgHighlight)
          
          Text(reservation.status.name)
            .fixedSize(horizontal: false, vertical: true)
            .font(.heading1)
            .foregroundColor(Color.onBg)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
          
          Text(reservation.status.description)
            .fixedSize(horizontal: false, vertical: true)
            .font(.lead)
            .foregroundColor(Color.onBg)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
        }
        
        VStack(spacing: FSUnit.main(.xl)) {
          FSText(
            restaurant.name,
            font: .heading2,
            alignment: .center,
            multilineAlignment: .center
          )
          
          HStack(spacing: .zero) {
            FSChip("Hoy, \(reservation.date.formatRelative())", icon: .calendar, rounded: false) // TODO: change to 'En n minutos' format somehow
            FSChip("\(reservation.noPeople)", icon: .people, rounded: false)
          }
          .clipShape(Capsule())
          
          FSText(
            restaurant.address,
            alignment: .center,
            multilineAlignment: .center
          )
        }
        .padding(.horizontal, FSUnit.side(.xxl))
        .padding(.vertical, FSUnit.main(.xxl))
        .background(Color.primaryBg)
        .clipShape(RoundedRectangle(cornerRadius: FSUnit.main(.xl), style: .continuous))
      }
      Spacer()
    }
    .padding(.horizontal, FSUnit.side(.xxl))
    .padding(.vertical, FSUnit.main(.xxl))
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity
    )
    .background(Color.secondaryBg)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        FSChip("Atrás", icon: .back) {
          self.dismiss()
        }
      }
    }
  }
}

//struct ReservationWaitView_Previews: PreviewProvider {
//  static var previews: some View {
//    ReservationWaitView()
//  }
//}
