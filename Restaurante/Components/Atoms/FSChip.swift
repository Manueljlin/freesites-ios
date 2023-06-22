/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct FSChip: View {
  
  //--------------------------------------------------------------------------//
  // Component types
  
  enum FSChipType {
    //
    // Toggle button
    case filter
    
    //
    // Action button
    case actionPrimary
    case actionRegular
  }
  
  
  //--------------------------------------------------------------------------//
  // Component props
  
  private let label:     String?
  private let icon:      FSIcon?
  private let type:      FSChipType
  private let rounded:   Bool
  private var compact:   Bool
  private let fullWidth: Bool
  private let active:    Binding<Bool>?
  private let action:    () -> Void
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ label:   String? = nil,
    icon:      FSIcon? = nil,
    type:      FSChipType = .filter,
    rounded:   Bool = true,
    compact:   Bool = true,
    fullWidth: Bool = false,
    active:    Binding<Bool>? = nil,
    action:    @escaping () -> Void = {}
  ) {
    //
    // value init
    self.label     = label
    self.icon      = icon
    self.type      = type
    self.rounded   = rounded
    self.compact   = compact
    self.fullWidth = fullWidth
    self.active    = active
    self.action    = action
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    Button {
      if let _ = self.active {
        self.active!.wrappedValue.toggle()
      } else {
        self.action()
      }
    } label: {
      HStack {
        if let icon = self.icon {
          Image(FSIcon.get(icon))
//            .foregroundColor()
        }
        if let label = self.label {
          Text(label)
            .font(
              self.active != nil && self.active!.wrappedValue || self.type == .actionPrimary
              ? .bodyBold
              : .bodyRegular
            )
            .frame(minHeight: FSUnit.main(.xxl))
        }
      }
      .if (self.fullWidth) { view in
        view.frame(maxWidth: .infinity)
      }
    }
    .buttonStyle(
      FSChipButtonStyle(
        type: self.type,
        rounded: self.rounded,
        compact: self.compact,
        active: self.active
      )
    )
  }
  
  
  //--------------------------------------------------------------------------//
  // ButtonStyle
  
  fileprivate struct FSChipButtonStyle: ButtonStyle {
    private let _animation = Animation.easeIn(duration: 0.04)
    
    private let type: FSChipType
    private let rounded: Bool
    private var compact: Bool
    private let active: Binding<Bool>?
    
    
    init(
      type: FSChipType,
      rounded: Bool,
      compact: Bool,
      active: Binding<Bool>?
    ) {
      self.type    = type
      self.rounded = rounded
      self.compact = compact
      self.active  = active
    }
    
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .padding(
          .horizontal,
          withAnimation(self._animation) {
            self.compact
            ? FSUnit.side(.m)
            : FSUnit.side(.ml)
          }
        )
        .padding(
          .vertical,
          withAnimation(self._animation) {
            self.compact
            ? FSUnit.main(.m)
            : FSUnit.main(.ml)
          }
        )
        .background({
          self.active != nil && self.active!.wrappedValue || self.type == .actionPrimary
          ? Color.highlightBg
          : Color.tertiaryBg
        }()
          .opacity(
            configuration.isPressed
            ? withAnimation(self._animation) { 0.6 }
            : withAnimation(self._animation) { 1 }
          )
        )
        .foregroundColor(
          self.active != nil && self.active!.wrappedValue || self.type == .actionPrimary
          ? Color.onHighlightBg
          : Color.onBg
        )
        .cornerRadius(self.rounded ? .infinity : .zero)
        .animation(self._animation, value: configuration.isPressed)
    }
  }
}


struct FSChip_Previews: PreviewProvider {
  static var previews: some View {
//    FSChip()
    EmptyView()
  }
}
