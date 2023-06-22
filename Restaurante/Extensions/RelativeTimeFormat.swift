import Foundation


extension String {
  
  /// Format a database datetime string to a relative, more human readable format
  func formatRelative() -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = Locale(identifier: "es_ES")
    formatter.timeZone = TimeZone(identifier: "Europe/Madrid")
    
    guard let date = formatter.date(from: self) else {
      return "--"
    }
    
    let now = Date()
    let components = Calendar.current.dateComponents(
      [.minute, .hour, .day, .weekOfYear],
      from: date,
      to: now
    )
    
    let formatString: String
    let absoluteComponents = DateComponents(
      calendar: Calendar.current,
      year: 0,
      month: 0,
      day: abs(components.day ?? 0),
      hour: abs(components.hour ?? 0),
      minute: abs(components.minute ?? 0),
      second: 0
    )
    
    if let relativeTime = DateComponentsFormatter
      .localizedString(from: absoluteComponents, unitsStyle: .full) {
      
      if now > date {
        if absoluteComponents.day == 1 {
          formatString = "Hace 1 día"
        } else if absoluteComponents.weekOfYear == 1 {
          formatString = "Hace 1 semana"
        } else {
          formatString = "Hace \(relativeTime)"
        }
      } else {
        if absoluteComponents.day == 1 {
          formatString = "En 1 día"
        } else if absoluteComponents.weekOfYear == 1 {
          formatString = "En 1 semana"
        } else {
          formatString = "En \(relativeTime)"
        }
      }
    } else {
      formatString = "Ahora mismo"
    }
    
    return formatString
  }
}
