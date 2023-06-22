/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI
import Map


struct SearchMapView: View {
  
  //--------------------------------------------------------------------------//
  // View Model
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  
  //--------------------------------------------------------------------------//
  // Map Configuration
  
  @State private var userTrackingMode = UserTrackingMode.follow
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    ZStack {
      Map(
        coordinateRegion: self.$restaurantViewModel.locationWithRadius,
        type: .mutedStandard,
        pointOfInterestFilter: .excludingAll,
        informationVisibility: .userLocation,
        interactionModes: [.pan, .pitch, .rotate, .zoom],
        userTrackingMode: self.$userTrackingMode,
        annotationItems: self.restaurantViewModel.filteredRestaurants,
        annotationContent: { restaurant in
          ViewMapAnnotation(coordinate: restaurant.coordinates.coordinate) {
            NavigationLink {
              RestaurantDetailsView(currentRestaurant: restaurant)
            } label: {
              VStack(spacing: .zero) {
                VStack(spacing: -2) { // I'm so, so sorry
                  FSText(restaurant.name, alignment: .center, multilineAlignment: .center)
                    .frame(maxWidth: 128) // woo, magic!
                    .padding(.horizontal, FSUnit.side(.m))
                    .padding(.vertical, FSUnit.main(.m))
                    .background(Color.tertiaryBg)
                  //                  .background(Color.tertiaryBg.opacity(0.5))
                  //                  .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: FSUnit.l.rawValue))
                  //                .opacity(
                  //                  self.restaurantViewModel.locationWithRadius.getDistancesInMeters().latitudinalMeters < 1500
                  //                  ? 1
                  //                  : 0.5
                  //                )
                  //              Text("\(self.restaurantViewModel.locationWithRadius.getDistancesInMeters().latitudinalMeters)")
                  //              .onTapGesture {
                  //                print(self.restaurantViewModel.locationWithRadius.getDistancesInMeters())
                  //              }
                  Image(systemName: "arrowtriangle.down.fill")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 10)
                    .foregroundColor(Color.tertiaryBg)
                }
                .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Image(FSIcon.get(.tableFilled))
                  .resizable()
                  .scaledToFit()
                  .frame(
                    width: 48, // so much magic!?1!?
                    height: 48
                  )
                  .foregroundColor(Color.onBgHighlight)
              }
            }
            .fixedSize()
          }
        }
      )
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
          
      // looks nice but it's buggy :(
      // unsurprising as it's using a private apple api
//      VStack {
//        VariableBlurView()
//            .frame(height: 150)
//            .allowsHitTesting(false)
//
//        Spacer()
//      }
    }
  }
}
