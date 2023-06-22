/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI
import Kingfisher


struct FSCard<Main: View, Side: View, Bottom: View>: View {
  
  //--------------------------------------------------------------------------//
  // Component props
  
  @ViewBuilder var main:   () -> Main
  @ViewBuilder var side:   () -> Side
  @ViewBuilder var bottom: () -> Bottom

  
  //--------------------------------------------------------------------------//
  // Internal component values
  
  private let _radius:             CGFloat = FSUnit.main(.xxl)
  private let _backgroundColor:    Color?
  private let _backgroundColorAlt: Color?
  
  private let _strokeColor:        Color?
  private let _strokeWidth:        CGFloat = 2
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    @ViewBuilder main:   @escaping () -> Main,
    @ViewBuilder side:   @escaping () -> Side   = { EmptyView() },
    @ViewBuilder bottom: @escaping () -> Bottom = { EmptyView() }
  ) {
    //
    // Value init
    self.main = main
    self.side = side
    self.bottom = bottom
    
    // Style setup
    self._backgroundColor    = Color.tertiaryBg
    self._backgroundColorAlt = Color.secondaryBg
    self._strokeColor        = nil
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      GeometryReader { geo in
        HStack(alignment: .top, spacing: 0) {
          self.side()
            .frame(maxWidth: geo.size.width / 2.15, maxHeight: .infinity)
          
          VStack(alignment: .leading, spacing: FSUnit.xs.rawValue) {
            self.main()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding(.horizontal, FSUnit.side(.l))
          .padding(.vertical, FSUnit.l.rawValue)
        }
      }
      .frame(height: 220)
      
      self.bottom()
        .frame(maxWidth: .infinity)
        .background(self._backgroundColorAlt)
    }
    .frame(maxWidth: .infinity)
    .background(self._backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: self._radius, style: .continuous))
  }
  
  
  //--------------------------------------------------------------------------//
  // ButtonStyle
  
  //fileprivate struct FSCardButtonStyle: ButtonStyle {
    
  //}
}


struct FSCardFactory<Labels:View, Bottom: View> {
  
  static func fromRestaurant(
    _ restaurant: Restaurant,
    @ViewBuilder labels: @escaping () -> Labels = { EmptyView() },
    @ViewBuilder bottom: @escaping () -> Bottom = { EmptyView() }
  ) -> some View {
    return FSCard {
      FSText(restaurant.name, font: .leadBold)
      Spacer()
      labels()
    } side: {
      GeometryReader { geo in
        KFImage
          .url(restaurant.profileImage)
          .cacheOriginalImage()
//          .appendProcessor(
//            DownsamplingImageProcessor(size: geo.size)
//            |> RoundCornerImageProcessor(cornerRadius: FSUnit.main(.xxl))
//          )
          .fade(duration: 0.25)
          .placeholder { _progress in
            ProgressView()
          }
          .resizable()
          .scaledToFill()
          .frame(width: geo.size.width, height: geo.size.height)
          .clipped()
      }
    } bottom: {
      bottom()
        .padding(FSUnit.main(.l))
    }
  }
}


struct FSCard_Previews: PreviewProvider {
  
  static var previews: some View {
    ScrollView {
      VStack(spacing: FSUnit.s.rawValue) {
        
//        ForEach(Restaurant.examples, id: \.id) { restaurant in
//          FSCardFactory.fromRestaurant(restaurant)
//        }
        
        
//        ForEach(0...1, id: \.self) { _ in
//          Text("a")
//        }
        
        FSCard {
          FSText("Ejemplo", font: .leadBold)
          Spacer()
        } side: {
          Color.highlightBg
        } bottom: {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FSUnit.m.rawValue) {
              FSButton("Llamar", icon: .phone)
              FSButton("Cancelar", icon: .cancel)
              FSButton("Test", icon: .calendar)
            }
            .padding(FSUnit.l.rawValue)
          }
        }
        
        
        FSCard {
          FSText("Ejemplo", font: .leadBold)
          Spacer()
        } side: {
          Color.highlightBg
        } bottom: {
          HStack(spacing: FSUnit.m.rawValue) {
            FSButton("Llamar", icon: .phone)
            FSButton("Cancelar", icon: .cancel)
          }
          .padding(FSUnit.l.rawValue)
        }
        
        
        
      }
      .padding(FSUnit.l.rawValue)
    }
//    .previewLayout(.sizeThatFits)
    .frame(maxHeight: .infinity)
    .background(Color.primaryBg)
    .environment(\.colorScheme, .dark)
    .previewDisplayName("Buttons")
  }
}
