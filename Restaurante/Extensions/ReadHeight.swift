import SwiftUI


// from https://swiftuirecipes.com/blog/getting-size-of-a-view-in-swiftui
// and  https://daringsnowball.net/articles/swiftui-size-to-fit-bottom-sheet/ -- thanks!

struct HeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat?

  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
  guard let nextValue = nextValue() else { return }
    value = nextValue
  }
}

private struct ReadHeightModifier: ViewModifier {
  private var sizeView: some View {
    GeometryReader { geometry in
      Color.clear.preference(key: HeightPreferenceKey.self, value: geometry.size.height)
    }
  }

  func body(content: Content) -> some View {
    content.background(sizeView)
  }
}

extension View {
  func readHeight() -> some View {
    self
      .modifier(ReadHeightModifier())
  }
}
