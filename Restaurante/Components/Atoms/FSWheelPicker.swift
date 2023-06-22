/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


// wow, this is useless.
struct FSWheelPicker<SelectionValue: Hashable, Content: View>: View {
  
  //--------------------------------------------------------------------------//
  // Component props
  
  private let title: String
  private let selection: Binding<SelectionValue>
  private let content: () -> Content
  
  
  //--------------------------------------------------------------------------//
  // Initializer
  
  init(
    _ title: String,
    selection: Binding<SelectionValue>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.selection = selection
    self.content = content
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some View {
    Picker(self.title, selection: self.selection) {
      self.content()
    }
    .pickerStyle(WheelPickerStyle.wheel)
    .padding(.horizontal, -FSUnit.side(.xs))
  }
}


//struct FSPickerWheel_Previews: PreviewProvider {
//  static var previews: some View {
//    FSPickerWheel()
//  }
//}
