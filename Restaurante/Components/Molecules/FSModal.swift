/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct FSModal<Main: View, Bottom: View>: View {
  
  //--------------------------------------------------------------------------//
  // Component types
  
  enum FSModalType {
    case normal
    case warning
  }
  
  
  //--------------------------------------------------------------------------//
  // Environment Values
  
  @Environment(\.dismiss) var dismiss
  @Environment(\.scenePhase) var scenePhase
  
  
  //--------------------------------------------------------------------------//
  // Component props
  
  public private(set) var title:    String
  public private(set) var subtitle: String?
  public private(set) var type:     FSModalType
  public private(set) var detents:  Set<PresentationDetent>?
  
  
  @ViewBuilder public private(set) var main:   Main
  @ViewBuilder public private(set) var bottom: Bottom
  
  
  //--------------------------------------------------------------------------//
  // private asdfadsfdadfsdafcrstgmneaecrsntaecrsntacinres
  
  @SceneStorage("FSModal.Height") private var _autoModalHeight = CGFloat(0)
  @State private var _thisIsTerrible: Int = .zero // this might be a crime of war
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ title:  String,
    subtitle: String? = nil,
    type:    FSModalType = .normal,
    detents: Set<PresentationDetent>? = nil,
    @ViewBuilder main:   @escaping () -> Main = { EmptyView() },
    @ViewBuilder bottom: @escaping () -> Bottom = { EmptyView() }
  ) {
    self.title    = title
    self.subtitle = subtitle
    self.type     = type
    self.detents  = detents
    self.main     = main()
    self.bottom   = bottom()
    
    self._autoModalHeight = 0
  }
  
  
  var body: some View {
    //
    // content
    VStack(spacing: .zero) {
      
      // header
      HStack(alignment: .top, spacing: .zero) {
        
        // title
        VStack(spacing: FSUnit.main(.ml)) {
          FSText(
            self.title,
            font: .heading2,
            color: self.type == .warning
              ? Color.onDangerousBg
              : Color.onBg
          )
          
          if let subtitle = self.subtitle {
            FSText(
              subtitle,
              color: self.type == .warning
                ? Color.onDangerousBg
                : Color.onBg
            )
          }
        }
//        .background(.red.opacity(0.2))
        .padding(.vertical, FSUnit.main(.xxl))
        .padding(.leading, FSUnit.side(.xxl))
        
        // dismiss bttn
        FSChip(icon: .cancel) {
          self.dismiss()
        }
//        .background(.red.opacity(0.2))
        .padding(.vertical, FSUnit.side(.l))
        .padding(.leading, FSUnit.side(.m))
        .padding(.trailing, FSUnit.side(.l))
      } // header ends here
//      .background(.red.opacity(0.2))
      
      if Main.self != EmptyView.self {
          self.main
          .frame(
            maxWidth: .infinity,
            maxHeight: self.detents == nil ? nil : .infinity
          )
//          .background(.green.opacity(0.2))
          .padding(.bottom, FSUnit.main(.xl))
          .padding(.horizontal, FSUnit.side(.xl))
//          .background(.green.opacity(0.2))
      }
      
      if Bottom.self != EmptyView.self {
        self.bottom
          .frame(maxWidth: .infinity)
//          .background(.blue.opacity(0.2))
          .padding(.bottom, FSUnit.main(.xl))
          .padding(.horizontal, FSUnit.side(.xl))
//          .background(.blue.opacity(0.2))
      }
    }
    .if (self.detents == nil) { view in
      view
        .readHeight()
        .onPreferenceChange(HeightPreferenceKey.self) { height in
//          print("in! \(height?.description ?? 0.description), \(self._thisIsTerrible)")
          if let height = height,
             height < 700, // magic! woo!
             self._thisIsTerrible <= 1 {
            self._autoModalHeight = height
            self._thisIsTerrible += 1
          }
        }
        .presentationDetents([.height(self._autoModalHeight)])
    }
    .if (self.detents != nil) { view in
      view.presentationDetents(self.detents!)
    }
    .presentationCornerRadius(FSUnit.main(.xxl) + FSUnit.main(.l))
    .presentationBackground(
      self.type == .warning
      ? Color.dangerousBg
      : Color.secondaryBg
    )
//    .presentationDragIndicator(.hidden)
  }
}


//struct FSModal_Previews: PreviewProvider {
//    static var previews: some View {
//        FSModal()
//    }
//}
