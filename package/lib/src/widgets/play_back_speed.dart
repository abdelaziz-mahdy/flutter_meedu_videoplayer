import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayBackSpeedButton extends StatelessWidget {
  final Responsive responsive;
  final TextStyle textStyle;
  const PlayBackSpeedButton(
      {Key? key, required this.responsive, required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
        //observables: [_.fullscreen],
        (__) {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(responsive.buttonSize() * 0.25),
        ),
        onPressed: () {
          _.customDebugPrint("s");
          _.togglePlaybackSpeed();

          _.controls = true;
        },
        child: Text(
          _.playbackSpeed.toString(),
          style: textStyle,
        ),
      );
    });
  }
}
