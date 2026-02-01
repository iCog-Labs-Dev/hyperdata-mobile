/// Screen size constants for adaptive UI behavior
class ScreenConstants {
  ScreenConstants._();

  /// Height threshold for small screen detection
  /// Screens below this height will use button navigation instead of swipe
  static const double smallScreenHeightThreshold = 550.0;

  /// Check if current screen is considered small
  static bool isSmallScreen(double screenHeight) {
    print('screenHeight: $screenHeight');
    return screenHeight < smallScreenHeightThreshold;
  }
}
