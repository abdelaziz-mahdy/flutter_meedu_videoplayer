import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/controls_container.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/secondary/secondary_bottom_controls.dart';

class SecondaryVideoPlayerControls extends StatelessWidget {
  final Responsive responsive;
  const SecondaryVideoPlayerControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return ControlsContainer(
      responsive: responsive,
      child: Stack(
        children: [
          // RENDER A CUSTOM HEADER
          if (_.header != null)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: _.header!,
            ),
          SecondaryBottomControls(
            responsive: responsive,
          ),
        ],
      ),
    );
  }
}
