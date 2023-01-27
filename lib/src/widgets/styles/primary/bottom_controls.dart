import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/utils.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/fullscreen_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/mute_sound_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/playBackSpeed.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/player_slider.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/video_fit_button.dart';

class PrimaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryBottomControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    final fontSize = responsive.ip(2.5);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize > 16 ? 16 : fontSize,
    );
    var durationControls = Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
      RxBuilder(
          //observables: [_.duration, _.position],
          (__) {
        return Text(
          _.duration.value.inMinutes >= 60
              ? printDurationWithHours(_.position.value)
              : printDuration(_.position.value),
          style: textStyle,
        );
      }),
      // END VIDEO POSITION
      SizedBox(width: 10),
      (responsive.height / responsive.width > 1)
          ? ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: PlayerSlider())
          : Expanded(child: PlayerSlider()),
      SizedBox(width: 10),
      // START VIDEO DURATION
      RxBuilder(
        //observables: [_.duration],
        (__) => Text(
          _.duration.value.inMinutes >= 60
              ? printDurationWithHours(_.duration.value)
              : printDuration(_.duration.value),
          style: textStyle,
        ),
      ),
    ]);
    // END VIDEO DURATION
    var otherControls = Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
      if (_.bottomRight != null) ...[_.bottomRight!, SizedBox(width: 5)],

      //if (_.enabledButtons.pip) PipButton(responsive: responsive),

      if (_.enabledButtons.videoFit) VideoFitButton(responsive: responsive),
      if (_.enabledButtons.playBackSpeed)
        PlayBackSpeedButton(responsive: responsive, textStyle: textStyle),
      if (_.enabledButtons.muteAndSound)
        MuteSoundButton(responsive: responsive),

      if (_.enabledButtons.fullscreen)
        FullscreenButton(
          size: responsive.ip(_.fullscreen.value ? 5 : 7),
        )
    ]);
    return Positioned(
      left: 5,
      right: 0,
      bottom: 20,
      child: (responsive.height / responsive.width > 1)
          ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.spaceAround,
              children: [durationControls, otherControls],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(child: durationControls), otherControls],
            ),
    );
  }
}
