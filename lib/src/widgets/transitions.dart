import 'package:flutter/material.dart';

class CustomOpacityTransition extends StatelessWidget {
  const CustomOpacityTransition({
    Key? key,
    this.visible,
    this.child,
  }) : super(key: key);

  final bool? visible;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 100),
      opacity: visible! ? 1 : 0,
      child: child!,
    );
  }
}
/*
class CustomSwipeTransition extends StatelessWidget {
  const CustomSwipeTransition({
    Key? key,
    this.visible,
    this.child,
    this.direction,
  }) : super(key: key);

  final bool? visible;
  final Widget? child;
  final SwipeDirection? direction;

  @override
  Widget build(BuildContext context) {
    final style = VideoViewerStyle();

    return SwipeTransition(
      curve: Curves.ease,
      duration: style.transitions,
      direction: direction!,
      visible: visible!,
      child: child!,
    );
  }
}*/
