import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/rewind_and_forward_layout.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/ripple_side.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/transitions.dart';

class VideoCoreForwardAndRewind extends StatelessWidget {
  const VideoCoreForwardAndRewind(
      {Key? key,
      required this.showRewind,
      required this.showForward,
      required this.forwardSeconds,
      required this.rewindSeconds,
      required this.responsive})
      : super(key: key);

  final bool showRewind, showForward;
  final int rewindSeconds, forwardSeconds;
  final Responsive responsive;
  @override
  Widget build(BuildContext context) {
    return VideoCoreForwardAndRewindLayout(
      responsive: responsive,
      rewind: CustomOpacityTransition(
        visible: showRewind,
        child: ForwardAndRewindRippleSide(
          text: "$rewindSeconds Sec",
          side: RippleSide.left,
        ),
      ),
      forward: CustomOpacityTransition(
        visible: showForward,
        child: ForwardAndRewindRippleSide(
          text: "$forwardSeconds Sec",
          side: RippleSide.right,
        ),
      ),
    );
  }
}
