/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct FSTabItem: View {
  
  //--------------------------------------------------------------------------//
  // Component props
  
  private let label:       String
  private let regularIcon: FSIcon
  private let activeIcon:  FSIcon
  private let active:      Binding<Bool>
  
  init(
    _ label:     String,
    regularIcon: FSIcon,
    activeIcon:  FSIcon,
    active:      Binding<Bool>
    
  ) {
    self.label = label
    self.regularIcon = regularIcon
    self.activeIcon = activeIcon
    self.active = active
  }
  
  
  var body: some View {
    Button {
      self.active.wrappedValue.toggle()
    } label: {
      VStack(spacing: FSUnit.main(.s)) {
        Image(FSIcon.get(
          self.active.wrappedValue
            ? self.activeIcon
            : self.regularIcon
        ))
        .resizable()
        .scaledToFit()
        .frame(width: 28, height: 28)
        
        Text(self.label)
          .fixedSize(horizontal: false, vertical: true)
          .font(
            self.active.wrappedValue
            ? Font.bodyBold
            : Font.bodyRegular
          )
          .frame(maxWidth: .infinity, alignment: .center)
          .multilineTextAlignment(.center)
      }
    }
    .buttonStyle(FSTabItemButtonStyle(active: self.active))
  }
  
  
  
  //--------------------------------------------------------------------------//
  // ButtonStyle
  
  fileprivate struct FSTabItemButtonStyle: ButtonStyle {
    private let _animation = Animation.easeOut(duration: 0.03)
    
    private let active: Binding<Bool>
    
    init(active: Binding<Bool>) {
      self.active = active
    }

    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .padding(.top, FSUnit.main(.ml))
        .padding(.bottom, FSUnit.main(.m))
        .padding(.horizontal, FSUnit.side(.s))
        .background(
          Color.primaryBg
            .opacity(
              configuration.isPressed
              ? withAnimation(self._animation) { 0.5 }
              : withAnimation(self._animation) { 0 }
            )
        )
        .foregroundColor(
          self.active.wrappedValue
          ? Color.onBgHighlight
          : Color.onBg
        )
        .animation(self._animation, value: configuration.isPressed)
    }
  }
}
