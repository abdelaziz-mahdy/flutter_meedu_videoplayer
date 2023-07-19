import 'package:flutter_meedu_videoplayer/bar.dart';
import 'package:flutter/material.dart';

class ForwardAndRewindStyle {
  /// With this argument change the icons that appear when double-tapping,
  /// also the style of the container that indicates when the video will be rewind or forward.
  const ForwardAndRewindStyle({
    BarStyle? bar,
    Widget? rewind,
    Widget? forward,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? ripple,
    this.spaceBetweenBarAndText = 10,
  })  : bar = bar ?? const BarStyle.forward(),
        padding = padding ?? const EdgeInsets.all(10),
        backgroundColor = backgroundColor ?? const Color.fromRGBO(0, 0, 0, 0.28),
        ripple = ripple ?? const Color.fromRGBO(255, 255, 255, 0.28),
        borderRadius =
            borderRadius ?? const BorderRadius.all(Radius.circular(10)),
        rewind = rewind ?? const Icon(Icons.fast_rewind, color: Colors.white),
        forward =
            forward ?? const Icon(Icons.fast_forward, color: Colors.white);

  /// The icon that appears momentarily when you double tap
  ///
  ///DEFAULT:
  ///```dart
  ///   Icon(Icons.fast_rewind, color: Colors.white);
  ///```
  final Widget rewind;

  /// The icon that appears momentarily when you double tap
  ///
  ///DEFAULT:
  ///```dart
  ///   Icon(Icons.fast_forward, color: Colors.white);
  ///```
  final Widget forward;

  /// The background color of the indicator of when time will advance
  /// or will slow down the video
  ///
  ///DEFAULT:
  ///```dart
  ///   Colors.black.withOpacity(0.28);
  ///```
  final Color backgroundColor;

  /// It is the padding that the forward and rewind indicator will have
  ///
  ///DEFAULT:
  ///```dart
  ///   Margin.all(5);
  ///   "NOTE: Margin is on Helpers pubdev library"
  ///```
  final EdgeInsetsGeometry padding;

  /// It is the borderRadius that will have the forward and rewind indicator
  ///
  ///DEFAULT:
  ///```dart
  ///   EdgeRadius.vertical(bottom: 5);
  ///   "NOTE: EdgeRadius is on Helpers pubdev library"
  ///```
  final BorderRadius borderRadius;

  ///DEFAULT:
  ///```dart
  ///BarStyle.forward()
  ///```
  final BarStyle bar;

  final double spaceBetweenBarAndText;

  ///On double tap for rewind or forward the video viewer shows a ripple.
  final Color ripple;
}
