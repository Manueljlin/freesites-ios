/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


enum FSIcon: String {
  case placeholder     = "placeholder"
  
  case back            = "icon_back"
  case calendar        = "icon_calendar"
  case cancel          = "icon_cancel"
  case checkmarkFilled = "icon_checkmark_filled"
  case checkmark       = "icon_checkmark"
  case clear           = "icon_clear"
  case currentLocation = "icon_current_location"
  case cutlery         = "icon_cutlery"
  case eyeClosed       = "icon_eye_closed"
  case eyeOpen         = "icon_eye_open"
  case filters         = "icon_filters"
  case likeFilled      = "icon_like_filled"
  case like            = "icon_like"
  case list            = "icon_list"
  case location        = "icon_location"
  case lock            = "icon_lock"
  case mail            = "icon_mail"
  case map             = "icon_map"
  case money           = "icon_money"
  case people          = "icon_people"
  case phone           = "icon_phone"
  case profileFilled   = "icon_profile_filled"
  case profile         = "icon_profile"
  case review          = "icon_review"
  case searchFilled    = "icon_search_filled"
  case search          = "icon_search"
  case share           = "icon_share"
  case starFilled      = "icon_star_filled"
  case starHalfFilled  = "icon_star_half_filled"
  case star            = "icon_star"
  case tableFilled     = "icon_table_filled"
  case table           = "icon_table"
  case terrace         = "icon_terrace"
  case time            = "icon_time"
  
  static func get(_ icon: FSIcon/*, bold: Bool = false*/) -> String {
    icon.rawValue
  }
}


struct FSIconView: View {
  
  private var icon: FSIcon
  
  init(_ icon: FSIcon) {
    self.icon = icon
  }
  
  var body: some View {
    Image(FSIcon.get(self.icon))
      .foregroundColor(Color.onBg)
  }
}
