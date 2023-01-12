import 'package:flutter/material.dart';

class VideoCoreForwardAndRewindLayout extends StatelessWidget {
  const VideoCoreForwardAndRewindLayout({
    Key? key,
    required this.rewind,
    required this.forward,
  }) : super(key: key);

  final Widget rewind;
  final Widget forward;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: rewind),
      SizedBox(width: (context.size?.width??0) / 3),
      Expanded(child: forward),
    ]);
  }
}
