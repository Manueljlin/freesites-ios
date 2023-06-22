/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


enum FSTextFieldType {
  case regular
  case password
}


struct FSTextField: View {
  
  //--------------------------------------------------------------------------//
  // Component props
  
  let icon:          FSIcon?
  let label:         String
  let type:          FSTextFieldType
  @Binding var text: String
  let keyboardType:  UIKeyboardType
  
  
  //--------------------------------------------------------------------------//
  // Internal component values
  
  private let _radius:          CGFloat = FSUnit.xl.rawValue
  private let _backgroundColor: Color?
  private let _foregroundColor: Color?
  
  private let _strokeColor:     Color?
  private let _strokeWidth:     CGFloat = 2
  
  
  //--------------------------------------------------------------------------//
  // Internal component states
  
  @State private var _showText: Bool
  
  @FocusState private var _focusOnHidden: Bool
  @FocusState private var _focusOnShown: Bool
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ label: String,
    icon: FSIcon? = nil,
    type: FSTextFieldType = .regular,
    text: Binding<String>,
    keyboardType: UIKeyboardType = .default
  ) {
    //
    // value init
    self.icon         = icon
    self.label        = label
    self.type         = type
    self._text        = text
    self.keyboardType = keyboardType
    
    //
    // style setup
    switch self.type {
    case .regular, .password:
      self._backgroundColor = Color.tertiaryBg
      self._foregroundColor = Color.onBg
      self._strokeColor     = Color.highlightBg
    }
    
    //
    // behavior setup
    switch self.type {
    case .regular:
      self._showText = true
    case .password:
      self._showText = false
    }
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    HStack(spacing: FSUnit.main(.l)) {
      if let icon = self.icon {
        Image(FSIcon.get(icon))
          .renderingMode(.template)
          .foregroundColor(Color.highlightBg)
      }
      ZStack {
        TextField(self.label, text: self.$text)
          .textInputAutocapitalization(.never)
          .keyboardType(self.keyboardType)
          .autocorrectionDisabled(true)
          .focused(self.$_focusOnShown)
          .opacity(self._showText ? 1 : 0)
        
        SecureField(self.label, text: self.$text)
          .textInputAutocapitalization(.never)
          .keyboardType(self.keyboardType)
          .autocorrectionDisabled(true)
          .focused(self.$_focusOnHidden)
          .opacity(self._showText ? 0 : 1)
      }
      
      if self.type == .password {
        Button(action: {
          self.toggleVisibility()
        }) {
          Image({
            if self._showText {
              return FSIcon.get(.eyeClosed)
            }
            return FSIcon.get(.eyeOpen)
          }())
          .renderingMode(.template)
          .animation(nil)
        }
      }
    }
    .font({
      if self.isFocused() {
        return .leadBold
      } else {
        return .lead
      }
    }())
    .padding(.horizontal, FSUnit.side(.xl))
    .padding(.vertical, FSUnit.main(.xl))
    .background(self._backgroundColor)
    .foregroundColor(self._foregroundColor)
    .clipShape(RoundedRectangle(cornerRadius: self._radius, style: .continuous))
    .overlay {
      if self._strokeColor != nil {
        RoundedRectangle(cornerRadius: self._radius, style: .continuous)
          .strokeBorder(self._strokeColor!, lineWidth: self._strokeWidth)
          .opacity(self.isFocused() ? 1 : 0)
      }
      EmptyView()
    }
  }
  
  func toggleVisibility() {
    self._showText.toggle()
    if self._showText {
      self._focusOnShown  = true
    } else {
      self._focusOnHidden = true
    }
  }
  
  func isFocused() -> Bool {
    return self._focusOnHidden || self._focusOnShown
  }
}


struct FSTextField_Previews: PreviewProvider {
  struct Container: View {
    
    @State var name     = ""
    @State var phone    = ""
    @State var email    = ""
    @State var password = ""
    
    var body: some View {
      ZStack(alignment: .top) {
        Color.primaryBg
          .onTapGesture {
            self.hideKeyboard()
          }
          .ignoresSafeArea()
        
        VStack {
          
          Spacer()
          
          Group {
            FSTextField("Nombre", icon: .profile, text: $name)
            FSTextField("Teléfono", icon: .phone, text: $phone, keyboardType: .phonePad)
            FSTextField("Correo", icon: .mail, text: $email, keyboardType: .emailAddress)
            FSTextField("Contraseña", icon: .lock, type: .password, text: $password, keyboardType: .asciiCapable)
          }
          
          Spacer()
        }
        .padding()
      }
      .onTapGesture {
      }
      .previewLayout(.sizeThatFits)
      .frame(maxHeight: .infinity)
      .environment(\.colorScheme, .dark)
      .previewDisplayName("Text Fields")
    }
  }
  
  static var previews: some View {
    Container()
  }
}
