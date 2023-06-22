/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


// from https://swiftuirecipes.com/blog/supporting-dark-mode-in-swiftui -- thanks!


//
// Detect current mode
extension UIColor {
  
  convenience init(light: UIColor, dark: UIColor) {
    self.init { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .light, .unspecified:
        return light
      case .dark:
        return dark
      @unknown default:
        return light
      }
    }
  }
}


extension Color {
  
  init(light: Color, dark: Color) {
    self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
  }
  
  
  //--------------------------------------------------------------------------//
  // Light
  
  //
  // base
  private static let primaryBgLight          = Color(red: 229 / 255, green: 232 / 255, blue: 234 / 255)
  private static let secondaryBgLight        = Color(red: 240 / 255, green: 242 / 255, blue: 243 / 255)
  private static let tertiaryBgLight         = Color.white
  private static let onBgLight               = secondaryBgDark
  private static let onBgHighlightLight      = Color(red: 146 / 255, green: 151 / 255, blue: 0 / 255)
  
  //
  // highlight
  private static let highlightBgLight        = Color(red: 208 / 255, green: 215 / 255, blue: 87 / 255)
  private static let onHighlightBgLight      = secondaryBgDark
  private static let onHighlightOutlineLight = secondaryBgDark
  
  //
  // dangerous
  private static let dangerousBgLight        = Color(red: 254 / 255, green: 99 / 255, blue: 105 / 255)
  private static let onDangerousBgLight      = secondaryBgDark
  private static let onDangerousOutlineLight = secondaryBgDark
  
  
  //--------------------------------------------------------------------------//
  // Dark
  
  //
  // base
  private static let primaryBgDark          = Color(red: 14 / 255, green: 24 / 255, blue: 27 / 255)
  private static let secondaryBgDark        = Color(red: 35 / 255, green: 48 / 255, blue: 53 / 255)
  private static let tertiaryBgDark         = Color(red: 60 / 255, green: 74 / 255, blue: 79 / 255)
  private static let onBgDark               = secondaryBgLight
  private static let onBgHighlightDark      = highlightBgLight
  
  //
  // highlight
  private static let highlightBgDark        = highlightBgLight
  private static let onHighlightBgDark      = secondaryBgDark
  private static let onHighlightOutlineDark = highlightBgDark
  
  //
  // dangerous
  private static let dangerousBgDark         = dangerousBgLight
  private static let onDangerousBgDark       = secondaryBgDark
  private static let onDangerousOutlineDark  = secondaryBgDark
  
  
  //--------------------------------------------------------------------------//
  // Adaptive
  
  static let primaryBg          = Color(light: .primaryBgLight,          dark: .primaryBgDark)
  static let secondaryBg        = Color(light: .secondaryBgLight,        dark: .secondaryBgDark)
  static let tertiaryBg         = Color(light: .tertiaryBgLight,         dark: .tertiaryBgDark)
  static let onBg               = Color(light: .onBgLight,               dark: .onBgDark)
  static let onBgHighlight      = Color(light: .onBgHighlightLight,      dark: .onBgHighlightDark)
  
  static let highlightBg        = Color(light: .highlightBgLight,        dark: .highlightBgDark)
  static let onHighlightBg      = Color(light: .onHighlightBgLight,      dark: .onHighlightBgDark)
  static let onHighlightOutline = Color(light: .onHighlightOutlineLight, dark: .onHighlightOutlineDark)
  
  static let dangerousBg        = Color(light: .dangerousBgLight,        dark: .dangerousBgDark)
  static let onDangerousBg      = Color(light: .onDangerousBgLight,      dark: .onDangerousBgDark)
  static let onDangerousOutline = Color(light: .onDangerousOutlineLight, dark: .onDangerousOutlineDark)
}
