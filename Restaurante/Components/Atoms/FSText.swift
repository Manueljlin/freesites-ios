/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct FSText: View {
  
  //--------------------------------------------------------------------------//
  // Component props
  
  @State var text: String
  @State var font: Font
  @State var color: Color
  
  @State var alignment: Alignment
  @State var multilineAlignment: TextAlignment
  
  let fullWidth: Bool
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ text:             String,
    font:               Font          = .bodyRegular,
    color:              Color         = .onBg,
    alignment:          Alignment     = .leading,
    multilineAlignment: TextAlignment = .leading,
    fullWidth:          Bool          = true
  ) {
    self.text               = text
    self.font               = font
    self.color              = color
    self.alignment          = alignment
    self.multilineAlignment = multilineAlignment
    self.fullWidth          = fullWidth
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    Text(text)
      .fixedSize(horizontal: false, vertical: true)
      .font(font)
      .foregroundColor(color)
      .frame(maxWidth: self.fullWidth ? .infinity : nil, alignment: alignment)
      .multilineTextAlignment(multilineAlignment)
  }
}
