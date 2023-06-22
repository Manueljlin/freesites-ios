/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct SearchFiltersView: View {
  
  //--------------------------------------------------------------------------//
  // Environment Values
  
  @Environment(\.dismiss) var dismiss
  
  
  //--------------------------------------------------------------------------//
  // View Model(s)
  
  @EnvironmentObject var restaurantViewModel: RestaurantViewModel
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    ZStack {
      Color.primaryBg
        .ignoresSafeArea()
      VStack(alignment: .leading, spacing: 0) {
        
        HStack {
          FSText("Filtros", font: .heading2, fullWidth: false)
          Spacer()
          FSChip("Borrar todo", icon: .clear) {
            self.restaurantViewModel.clearFilters()
          }
          FSChip(icon: .cancel, type: .actionRegular) { self.dismiss() }
        }
        .padding(.leading, FSUnit.side(.xl))
        .padding(.trailing, FSUnit.side(.m))
        .padding(.vertical, FSUnit.main(.xl))
        .background(Color.secondaryBg)
        
        ScrollView {
          VStack(spacing: 0) {
            VStack(spacing: FSUnit.main(.xl)) {
              HStack(spacing: FSUnit.side(.xl)) {
                HStack(spacing: FSUnit.side(.s)) {
                  Image(FSIcon.star.rawValue)
                  FSText("Nota media mínima", font: .leadBold)
                }
                FSChip(String(format: "%.0f estrellas", self.restaurantViewModel.minAvgScore))
              }
              VStack(spacing: FSUnit.main(.m)) {
                Slider(
                  value: self.$restaurantViewModel.minAvgScore,
                  in: 0...5,
                  step: 1
                )
                HStack(spacing: 0) {
                  FSText("0", alignment: .center)
                  FSText("1", alignment: .center)
                  FSText("2", alignment: .center)
                  FSText("3", alignment: .center)
                  FSText("4", alignment: .center)
                  FSText("5", alignment: .center)
                }
                .padding(.horizontal, -20) // :(
              }
            }
            .padding(.horizontal, FSUnit.side(.l))
            .padding(.vertical, FSUnit.main(.l))
            Divider()
          }
          VStack(spacing: 0) {
            VStack(spacing: FSUnit.main(.xl)) {
              HStack(spacing: FSUnit.side(.xl)) {
                HStack(spacing: FSUnit.side(.s)) {
                  Image(FSIcon.money.rawValue)
                  FSText("Precio medio máximo", font: .leadBold)
                }
                FSChip(String(format: "Hasta %.0f €", self.restaurantViewModel.maxAvgPrice))
              }
              VStack(spacing: FSUnit.m.rawValue) {
                Slider(
                  value: self.$restaurantViewModel.maxAvgPrice,
                  in: 0...50,
                  step: 1
                )
                HStack(spacing: 0) {
                  FSText("0€", alignment: .leading)
                  
                  Spacer()
                  
                  FSText("50€", alignment: .trailing)
                }
                .padding(.horizontal, 6)
              }
            }
            .padding(.horizontal, FSUnit.side(.l))
            .padding(.vertical, FSUnit.main(.l))
            Divider()
          }
          VStack(spacing: .zero) {
            VStack(spacing: FSUnit.xl.rawValue) {
              HStack(spacing: FSUnit.side(.xl)) {
                HStack(spacing: FSUnit.side(.s)) {
                  Image(FSIcon.get(.location))
                  FSText("Distancia máxima", font: .leadBold)
                }
                FSChip({
                  switch self.restaurantViewModel.maxDistance {
                  case ...999: return String(format: "Hasta %.0f m", self.restaurantViewModel.maxDistance)
                  default:     return String(format: "Hasta %.1f km", self.restaurantViewModel.maxDistance / 1000)
                  }
                }())
              }
              VStack(spacing: FSUnit.m.rawValue) {
                Slider(
                  value: self.$restaurantViewModel.maxDistance,
                  in: 500...8000,
                  step: 500,
                  onEditingChanged: { _ in self.restaurantViewModel.updateLocationWithRadius() }
                )
                HStack(spacing: 0) {
                  FSText("500 m", alignment: .leading)
                  
                  Spacer()
                  
                  FSText("8km ", alignment: .trailing)
                }
                .padding(.horizontal, 6)
              }
            }
            .padding(.horizontal, FSUnit.side(.l))
            .padding(.vertical, FSUnit.l.rawValue)
            Divider()
          }
          VStack(spacing: FSUnit.xs.rawValue) {
            FSText("Tipos de comida", font: .leadBold)
              .padding(.bottom, FSUnit.main(.l))
            
            ForEach(FoodType.allCases, id: \.rawValue) { foodType in
              FSToggle(foodType.name, type: .checkbox, isOn: Binding(
                get: { self.restaurantViewModel.onlyTypes.contains(foodType) },
                set: { _,_ in self.restaurantViewModel.toggleFoodType(foodType) }
              ))
            }
            //Text(self.restaurantViewModel.onlyTypes.debugDescription)
          }
          .padding(.vertical, FSUnit.side(.xl))
          .padding(.horizontal, FSUnit.side(.xl))
        }
        
        VStack(spacing: .zero) {
          Divider()
          FSButton({
              switch self.restaurantViewModel.filteredRestaurants.count {
              case 0:  return "Ningún restaurante disponible :("
              case 1:  return "¡Hay un restaurante disponible!"
              default: return "¡Hay \(self.restaurantViewModel.filteredRestaurants.count) restaurantes disponibles!"
              }
            }(),
            type: .primary,
            fullWidth: true
          ) { self.dismiss() }
            .padding(.vertical, FSUnit.main(.xl))
            .padding(.horizontal, FSUnit.side(.xl))
            .disabled(self.restaurantViewModel.filteredRestaurants.count == 0)
        }
      }
      .padding(.bottom, FSUnit.main(.xl))
      .frame(alignment: .topLeading)
    }
  }
}
