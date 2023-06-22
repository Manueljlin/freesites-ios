/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct FSButton: View {
  
  //--------------------------------------------------------------------------//
  // Component types
  
  enum FSButtonType {
    case regular
    case primary
    case secondary
  }
  
  
  //--------------------------------------------------------------------------//
  // Component props
  
  private let icon:      FSIcon?
  private let label:     String?
  private let type:      FSButtonType
  private let fullWidth: Bool
  private let action:    () -> Void
  
  
  //--------------------------------------------------------------------------//
  // Internal component values
  
  @Environment(\.isEnabled) private var isEnabled: Bool
  
  private let _radius:          CGFloat = FSUnit.xl.rawValue
  private let _backgroundColor: Color?
  private let _foregroundColor: Color?
  
  private let _strokeColor:     Color?
  private let _strokeWidth:     CGFloat = 2
  private let _font:            Font
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ label:   String? = nil,
    icon:      FSIcon? = nil,
    type:      FSButtonType = .regular,
    fullWidth: Bool = true,
    action:    @escaping () -> Void = {}
  ) {
    //
    // Value init
    self.icon      = icon
    self.label     = label
    self.type      = type
    self.fullWidth = fullWidth
    self.action    = action
    
    //
    // Style setup
    switch self.type {
    case .regular:
      self._backgroundColor = Color.tertiaryBg
      self._foregroundColor = Color.onBg
      self._strokeColor     = nil
      self._font            = .lead
     
    case .primary:
      self._backgroundColor = Color.highlightBg
      self._foregroundColor = Color.onHighlightBg
      self._strokeColor     = nil
      self._font            = .leadBold
      
    case .secondary:
      self._backgroundColor = nil
      self._foregroundColor = Color.onHighlightOutline
      self._strokeColor     = Color.highlightBg
      self._font            = .leadBold
    }
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    Button {
      self.action()
    } label: {
      switch (self.icon, self.label) {
      case (.some(self.icon), .some(self.label)): // neither of them are null
        Label {
          Text(self.label!)
            .frame(height: FSUnit.main(.xxl))
        } icon: {
          Image(self.icon!.rawValue)
            .renderingMode(.template)
            .frame(height: FSUnit.main(.xxl))
        }
        .if (self.fullWidth) { view in
          view.frame(maxWidth: .infinity)
        }
        
      case (.some(self.icon), .none):             // label is null
        Image(self.icon!.rawValue)
          .renderingMode(.template)
          .frame(height: FSUnit.main(.xxl))
          .if (self.fullWidth) { view in
            view.frame(maxWidth: .infinity)
          }
        
      case (.none, .some(self.label)):            // icon is null
        Text(self.label!)
          .frame(height: FSUnit.main(.xxl))
          .if (self.fullWidth) { view in
            view.frame(maxWidth: .infinity)
          }
        
      default: EmptyView()
      }
    }
    .font(self._font)
    .padding(.horizontal, {
      if case .none = label {   // if label is null...
        return FSUnit.main(.xl) // ...don't add extra side padding
      }
      return FSUnit.side(.xl)   // else, actually do
    }())
    .padding(.vertical, FSUnit.xl.rawValue)
    .background(self._backgroundColor?.opacity(self.isEnabled ? 1 : 0.5))
    .foregroundColor(self._foregroundColor)
    .clipShape(RoundedRectangle(cornerRadius: self._radius, style: .continuous))
    .overlay(content: {
      if self._strokeColor != nil {
        RoundedRectangle(cornerRadius: self._radius, style: .continuous)
          .strokeBorder(self._strokeColor!, lineWidth: self._strokeWidth)
          //.opacity(0.5)
      }
      EmptyView()
    })
  }
  
  
  //--------------------------------------------------------------------------//
  // ButtonStyle
  
  // TODO: actually do the thing lol, tho it works fine rn without it
  fileprivate struct FSButtonButtonStyle: ButtonStyle { // nice name :D
//    @Environment(\.isEnabled) var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
//        .opacity(self.isEnabled ? 1 : 0.5)
    }
  }
}


struct FSButtonView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      
      Group {
        FSText("Botones de ejemplo", font: .heading2)
        FSText("No representan funcionalidad real de la app")
      }
      
      Divider()
      
      Group {
        FSButton("Regular")
        FSButton("Primary", type: .primary)
        FSButton("Secondary", type: .secondary)
      }
      
      Divider()
      
      Group {
        FSButton("Ver la fecha de la reserva", icon: .calendar)
        FSButton("Ver ubicación en Maps", icon: .location, type: .primary)
        FSButton("Llamar al restaurante", icon: .phone, type: .secondary)
      }
      
      Divider()
      
      ScrollView(.horizontal) {
        HStack {
          FSButton("Llamar", icon: .phone, fullWidth: false)
          FSButton("Llamar", fullWidth: false)
          FSButton(icon: .phone, fullWidth: false)
          FSButton(icon: .phone, type: .primary, fullWidth: false)
          FSButton(icon: .phone, type: .secondary, fullWidth: false)
        }
      }
    }
    .previewLayout(.sizeThatFits)
    .frame(maxHeight: .infinity)
    .padding(FSUnit.main(.xxl))
    .background(Color.primaryBg)
    .environment(\.colorScheme, .dark)
    .previewDisplayName("Buttons")
  }
}
