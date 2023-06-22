/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI
import VFont


extension Font {
  
  static func recursiveVar(
    size:    CGFloat,
    weight:  CGFloat,
    slant:   CGFloat = 0,
    mono:    CGFloat = 0,
    cursive: CGFloat = 0) -> Font
  {
    return .vFont("Recursive", size: size, axes: [
      2003265652: weight, //   300...1000 -- default 300
      1936486004: slant,  //   -15...0    -- default 0
      1297043023: mono,   //     0...1    -- default 0
      1129468758: cursive //     0...1    -- default 0.5
    ])
  }
  
  //--------------------------------------------------------------------------//
  
  static var bigTitle = Font
    .recursiveVar(size: 64, weight: 1000, slant: 0, mono: 0, cursive: 0.5)
  
  static var heading1 = Font
    .recursiveVar(size: 32, weight: 1000, slant: 0, mono: 0, cursive: 0.5)
  
  static var heading2 = Font
    .recursiveVar(size: 24, weight: 1000, slant: 0, mono: 0, cursive: 0.5)
  
  //--------------------------------------------------------------------------//
  
  // visually compensated .leadBold for the restaurant details rating
  static var ratingBlack = Font
    .recursiveVar(size: 20, weight: 900, slant: 0, mono: 0, cursive: 0.5)
  
  //--------------------------------------------------------------------------//
  
  static var leadBold = Font
    .recursiveVar(size: 18, weight: 800, slant: 0, mono: 0, cursive: 0.5)
  
  static var lead = Font
    .recursiveVar(size: 18, weight: 400, slant: 0, mono: 0, cursive: 0.5)
  
  static var bodyBold = Font
    .recursiveVar(size: 15, weight: 700, slant: 0, mono: 0, cursive: 0.5)
  
  static var bodyRegular = Font
    .recursiveVar(size: 15, weight: 400, slant: 0, mono: 0, cursive: 0.5)
}
