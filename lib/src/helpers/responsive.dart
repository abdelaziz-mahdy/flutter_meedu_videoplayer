import 'dart:math';

/// A utility class that helps make the UI responsive by defining the size of
/// icons, buttons, and text relative to the screen size.
class Responsive {
  /// The width of the screen.
  late double width;

  /// The height of the screen.
  late double height;

  /// The diagonal size of the screen in inches.
  late double inch;

  /// The relative size of icons, expressed as a percentage of the screen size.
  double iconsSizeRelativeToScreen;

  /// The relative size of buttons, expressed as a percentage of the screen size.
  double buttonsSizeRelativeToScreen;

  /// The relative font size, expressed as a percentage of the screen size.
  double fontSizeRelativeToScreen;

  /// The maximum size of icons.
  double maxIconsSize;

  /// The maximum size of buttons.
  double maxButtonsSize;

  /// The maximum font size.
  double maxFontSize;

  /// Creates a new [Responsive] instance.
  ///
  /// The optional parameters [fontSizeRelativeToScreen], [iconsSizeRelativeToScreen],
  /// and [buttonsSizeRelativeToScreen] specify the relative size of fonts,
  /// icons, and buttons, respectively, as a percentage of the screen size. The
  /// optional parameters [maxFontSize], [maxIconsSize], and [maxButtonsSize]
  /// specify the maximum size of fonts, icons, and buttons, respectively.
  Responsive({
    this.fontSizeRelativeToScreen = 2.5,
    this.maxFontSize = 16,
    this.iconsSizeRelativeToScreen = 7,
    this.maxIconsSize = 60,
    this.buttonsSizeRelativeToScreen = 8,
    this.maxButtonsSize = 60,
  });

  /// Sets the screen dimensions.
  void setDimensions(
    double widthProvided,
    double heightProvided,
  ) {
    width = widthProvided;
    height = heightProvided;
    inch = sqrt((width * width) + (height * height));
  }

  /// Calculates the actual size of an icon, taking into account the relative
  /// size and the maximum size.
  double iconSize() {
    return min(ip(iconsSizeRelativeToScreen), maxIconsSize);
  }

  /// Calculates the actual size of a button, taking into account the relative
  /// size and the maximum size.
  double buttonSize() {
    return min(ip(buttonsSizeRelativeToScreen), maxButtonsSize);
  }

  /// Calculates the actual font size, taking into account the relative size
  /// and the maximum size.
  double fontSize() {
    return min(ip(fontSizeRelativeToScreen), maxFontSize);
  }

  /// Converts a percentage of the screen size into inches.
  double ip(double percent) {
    return inch * percent / 100;
  }

  /// Converts a percentage of the screen width into logical pixels.
  double wp(double percent) {
    return width * percent / 100;
  }

  /// Converts a percentage of the screen height into logical pixels.
  double hp(double percent) {
    return height * percent / 100;
  }
}
