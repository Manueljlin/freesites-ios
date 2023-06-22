/*
 * This file isn't under the MIT license, unlike the rest of the project,
 * because it's either partly or fully based on a post from StackOverflow.
 * As such, it follows the CC-BY-SA 4.0 license from StackOverflow.
 *
 * Original author: https://stackoverflow.com/users/1047966/ondrej-stocek
 * From: https://stackoverflow.com/a/40868784/17629516 -- thanks!
 */


import Foundation


extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
