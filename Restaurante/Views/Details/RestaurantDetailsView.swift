/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI
import Kingfisher


struct RestaurantDetailsView: View {
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  @Environment(\.dismiss) var dismiss
  @State var currentRestaurant: Restaurant
  @State private var _isFavorite: Bool = false
  @State private var _showReservationConfirmationModal: Bool = false
  @State private var _navigateToReservationWaitView: Bool = false
  
  
  var body: some View {
    VStack(alignment: .leading, spacing: .zero) {
      TabView() {
        if let imageGallery = self.currentRestaurant.imageGallery {
          ForEach(imageGallery, id: \.self) { image in
            FSDetailsViewImage(image: image)
              .ignoresSafeArea()
              .tag(image)
          }
        }
      }
      .overlay(
        LinearGradient(
          gradient: Gradient(colors: [
            Color.primaryBg.opacity(0.85),
            Color.primaryBg.opacity(0.7),
            Color.primaryBg.opacity(0.5),
            Color.primaryBg.opacity(0.25),
            Color.primaryBg.opacity(0.2),
            Color.primaryBg.opacity(0.1),
            Color.primaryBg.opacity(0),
            Color.primaryBg.opacity(0)
          ]),
          startPoint: .top,
          endPoint: .center)
        .allowsHitTesting(false)
      )
      .ignoresSafeArea()
      .aspectRatio(2/1.62, contentMode: .fit)
      .tabViewStyle(.page)
      
      VStack(spacing: .zero) { // Restaurant description
        VStack { // Restaurant header
          FSText(
            self.currentRestaurant.name,
            font: .heading1,
            alignment: .leading,
            multilineAlignment: .leading
          )

          FSStar(rating: self.currentRestaurant.avgScore)
        }
        .padding(.horizontal, FSUnit.side(.xxl))
        .padding(.vertical, FSUnit.xxl.rawValue)

        Divider()

        VStack(alignment: .leading, spacing: FSUnit.main(.l)) {
//          FSButton("Ver opiniones", icon: .review)
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FSUnit.side(.xs)) {
              FSChip(String(self.currentRestaurant.avgPrice) + " €")
                .padding(.leading, FSUnit.side(.l))
              FSChip(self.currentRestaurant.foodType.name)
              FSChip("1 km")
              FSChip(
                self.currentRestaurant.hasTerrace
                ? "Con terraza"
                : "Sin terraza"
              )
                .padding(.trailing, FSUnit.side(.l))
            }
          }
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FSUnit.side(.xs)) {
              FSChip("Hoy")
                .padding(.leading, FSUnit.side(.l))
              FSChip(self.currentRestaurant.status.name)
            }
          }
        }
        .padding(.vertical, FSUnit.l.rawValue)
        .frame(maxHeight: .infinity)

        HStack {
          FSButton("Ver la carta", type: .secondary)
          FSButton("Reservar", type: .primary) {
            self._showReservationConfirmationModal.toggle()
          }
        }
        .padding(.horizontal, FSUnit.side(.l))
        .padding(.bottom, FSUnit.l.rawValue)

      } // Restaurant description ends here
      .frame(maxHeight: .infinity)
    }
    .sheet(isPresented: self.$_showReservationConfirmationModal) {
      ReservationConfirmationModal(
        toggleOnConfirm: self.$_navigateToReservationWaitView
      )
    }
    .navigationDestination(isPresented: self.$_navigateToReservationWaitView) {
      ReservationWaitView()
    }
    .background(Color.primaryBg)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        FSChip("Atrás", icon: .back) {
          self.dismiss()
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        FSChip(
          icon: self._isFavorite ? .likeFilled : .like,
          active: self.$_isFavorite
        )
      }
    }
  }
}


struct FSStar: View {
  
  private var rating: Double
  private var counter: Int = .zero
  
  init(rating: Double) {
    self.rating = rating
  }
  
  var body: some View {
    HStack(spacing: FSUnit.side(.s)) {
      FSText(String(self.rating), font: .ratingBlack, fullWidth: false)

      HStack(spacing: .zero) {
        
        ForEach(1...5, id: \.self) { i in
          if i <= Int(self.rating.rounded(.towardZero)) {
            Image(FSIcon.get(.starFilled))
          } else if 0.1...0.9 ~= (Double(i) - self.rating) { // meh, accurate enough
            Image(FSIcon.get(.starHalfFilled))
          } else {
            Image(FSIcon.get(.star))
          }
        }
      }
      Spacer()
    }
  }
}


struct FSDetailsViewImage: View {
  
  private var image: URL?
  
  init(image: URL?) {
    self.image = image
  }
  
  var body: some View {
    KFImage
      .url(image)
      .cacheOriginalImage()
      .fade(duration: 0.25)
      .placeholder { _ in
        ProgressView()
      }
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(
        minWidth: .zero,
        maxWidth: .infinity,
        minHeight: .zero,
        maxHeight: .infinity
      )
      .clipped()
//      .background(Color.purple)
//      .border(.green.opacity(0.7), width: 6)
  }
}


//----------------------------------------------------------------------------//
// Preview

//struct RestaurantDetailsView_Previews: PreviewProvider {
//  static var previews: some View {
//    RestaurantDetailsView(currentRestaurant: Restaurant.examples.first!)
//      .preferredColorScheme(.dark)
//  }
//}
