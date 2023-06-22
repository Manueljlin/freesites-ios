//https://stackoverflow.com/a/49697266/17629516
// by https://stackoverflow.com/users/2303865/leo-dabus -- thanks!


import Foundation


protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }


extension CaseIterableDefaultsLast {
  init(from decoder: Decoder) throws {
    self = try Self(
      rawValue: decoder
        .singleValueContainer()
        .decode(RawValue.self)
    ) ?? Self.allCases.last!
  }
}
