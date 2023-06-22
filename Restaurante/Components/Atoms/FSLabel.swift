/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


struct FSLabel: View {
  
  //--------------------------------------------------------------------------//
  // Component props
  
  let icon:      FSIcon
  let label:     String
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ label: String,
    icon: FSIcon
  ) {
    //
    // Value init
    self.icon      = icon
    self.label     = label
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    HStack(
      alignment: .center,
      spacing: FSUnit.main(.m)
    ) {
      Image(FSIcon.get(self.icon))
        .renderingMode(.template)
      FSText(self.label, font: .bodyBold)
    }
    .foregroundColor(Color.onBg)
    .opacity(0.5) // woo, magic!
  }
}

struct FSLabel_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: FSUnit.main(.s)) {
      FSLabel("Pescados", icon: .cutlery)
      FSLabel("4.5",      icon: .star)
      FSLabel("$35",      icon: .money)
      FSLabel("a 10 km",  icon: .location)
    }
    .padding(24)
  }
}
