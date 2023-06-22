/*
 * This file isn't under the MIT license, unlike the rest of the project,
 * because it's either partly or fully based on a post from StackOverflow.
 * As such, it follows the CC-BY-SA 4.0 license from StackOverflow.
 *
 * Original author: https://stackoverflow.com/users/3991269/dmitry
 * From: https://stackoverflow.com/a/76154592/17629516 -- thanks!
 */


import UIKit


extension UINavigationController: UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }

  // To make it work with ScrollView
  // public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
  //   true
  // }

  // To make it work also with ScrollView but not simultaneously
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    true
  }
}
