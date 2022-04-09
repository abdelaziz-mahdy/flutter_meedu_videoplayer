import 'package:flutter/material.dart';

class BarStyle {
  final BorderRadius borderRadius;
  final Color secondBackground;
  final double identifierWidth;
  final Color identifier;
  final Color background;
  final double height;
  final double width;
  final Color color;

  /// The **[height]** of the progress bar. ** NOTE: ** The radius of the point is proportional to the [height
  /// ]
  /// The **[color]** is the color of the current video progress in the progress bar
  ///
  /// The **[dot]** is the color that the progress Dot will have
  ///
  /// The **[background]** is the color of the progress bar
  ///
  /// The **[buffered]** is the color of the amount of the damping video
  /// in the progress bar
  ///
  /// The **[borderRadius]** of the border that will have the progress bar and the PreviewFrame
  BarStyle.progress({
    this.height = 5,
    double dotSize = 5,
    Color? dot,
    Color? color,
    Color? buffered,
    Color? background,
    BorderRadius? borderRadius,
  })  : this.width = double.infinity,
        this.identifier = dot ?? Colors.white,
        this.color = color ?? Color(0xFF295acc),
        this.secondBackground = buffered ?? Colors.white.withOpacity(0.3),
        this.background = background ?? Colors.white.withOpacity(0.2),
        this.borderRadius =
            borderRadius ?? BorderRadius.all(Radius.circular(5)),
        this.identifierWidth = dotSize;

  /// The **[borderRadius]** that the VolumeBar will have
  ///
  /// The **[background]** that the VolumeBar will have
  ///
  /// The **[color]** of the active volume that the VolumeBar will have
  ///
  /// The **[width]** and **[height]** are the Size that the VolumeBar will have
  BarStyle.volume({
    this.width = 5,
    this.height = 120,
    Color? color,
    Color? background,
    BorderRadius? borderRadius,
  })  : this.identifier = Colors.transparent,
        this.color = color ?? Colors.white,
        this.secondBackground = Colors.transparent,
        this.background = background ?? Colors.white.withOpacity(0.2),
        this.borderRadius =
            borderRadius ?? BorderRadius.all(Radius.circular(5)),
        this.identifierWidth = 0.0;

  BarStyle.forward({
    this.width = 120,
    this.height = 5,
    Color? color,
    Color? background,
    Color? identifier,
    double identifierWidth = 2.0,
    BorderRadius? borderRadius,
  })  : this.identifier = identifier ?? Colors.red,
        this.color = color ?? Colors.white,
        this.secondBackground = Colors.transparent,
        this.background = background ?? Colors.white.withOpacity(0.2),
        this.borderRadius =
            borderRadius ?? BorderRadius.all(Radius.circular(5)),
        this.identifierWidth = identifierWidth;
}
