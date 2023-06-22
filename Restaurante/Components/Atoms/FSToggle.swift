/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct FSToggle: View {
  
  //--------------------------------------------------------------------------//
  // Component types
  
  enum FSToggleType {
    case checkbox
    case toggle
  }
  
  
  //--------------------------------------------------------------------------//
  // Component props
  
  let label: String
  let icon: FSIcon?
  let type: FSToggleType
  @Binding var isOn: Bool
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ label: String,
    icon: FSIcon? = nil,
    type: FSToggleType = .toggle,
    isOn: Binding<Bool>
  ) {
    self.label = label
    self.icon = icon
    self.type = type
    self._isOn = isOn
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    Toggle(self.label, isOn: self._isOn)
      .toggleStyle(
        FSToggleStyle(
          label: self.label,
          icon: self.icon,
          type: self.type
        )
      )
  }
  
  
  //--------------------------------------------------------------------------//
  // ToggleStyle
  
  fileprivate struct FSToggleStyle: ToggleStyle {
    private let feedbackGen = UIImpactFeedbackGenerator(style: .light)
    private let animation = Animation.easeIn(duration: 0.04)
    
    private let label: String
    private let icon: FSIcon?
    private let type: FSToggleType
    
    init(
      label: String,
      icon: FSIcon?,
      type: FSToggleType
    ) {
      self.label = label
      self.icon  = icon
      self.type  = type
    }
    
    func makeBody(configuration: Configuration) -> some View {
      let isOnBinding = Binding<Bool>( // haptic feedback
        get: { configuration.isOn },
        set: { newValue in
          configuration.isOn = newValue
          feedbackGen.impactOccurred(intensity: 0.5)
        }
      )
      
      return HStack(spacing: FSUnit.main(.l)) {
        FSText(self.label, font: .lead)
        
        Button {
          withAnimation(self.animation) {
            //configuration.isOn.toggle()
            isOnBinding.wrappedValue.toggle()
          }
        } label: {
          if self.type == .checkbox {
            RoundedRectangle(cornerRadius: FSUnit.main(.ml), style: .continuous)
              .foregroundColor(
                configuration.isOn
                ? Color.highlightBg
                : Color.tertiaryBg
              )
              .frame(width: 26, height: 26)
              .overlay(
                configuration.isOn
                ? AnyView(
                  Image(FSIcon.get(.checkmarkFilled))
                    .foregroundColor(Color.onHighlightBg)
                )
                : AnyView(EmptyView()) // depressing workaround but oh well
              )
          } else {
            HStack(spacing: .zero) {
              if configuration.isOn {
                Spacer()
              }
              Circle()
                .foregroundColor(
                  configuration.isOn ? Color.onHighlightBg : Color.onBg
                )
              if !configuration.isOn {
                Spacer()
              }
            }
            .padding(FSUnit.main(.xs))
            .background(
              configuration.isOn
                ? Color.highlightBg
                : Color.tertiaryBg
            )
            .clipShape(Capsule())
            //.frame(width: 48, height: 26)
            .frame(width: 56, height: 32)
          }
        }
        .padding(.vertical, FSUnit.main(.l)) // increase touch area
        .padding(.leading, FSUnit.side(.l))
        .padding(.trailing, FSUnit.main(.xs))
        .buttonStyle(.plain)
//        .background(Color.blue.opacity(0.2))
      }
//      .background(Color.red.opacity(0.2))
    }
  }
}
