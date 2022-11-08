import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/utils.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/fullscreen_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/mute_sound_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/play_back_speed.dart';
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
    return Stack(
      children: [
        Positioned(
          left: 4,
          right: 0,
          bottom: 8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // START VIDEO POSITION
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
              const SizedBox(width: 8),
              const Expanded(
                child: PlayerSlider(),
              ),
              const SizedBox(width: 8),
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
              // END VIDEO DURATION
              const SizedBox(width: 8),
              if (_.bottomRight != null) ...[
                _.bottomRight!,
                const SizedBox(width: 4)
              ],

              //if (_.enabledButtons.pip) PipButton(responsive: responsive),

              if (_.enabledButtons.videoFit) VideoFitButton(responsive: responsive),
              if (_.enabledButtons.playBackSpeed)
                PlayBackSpeedButton(responsive: responsive, textStyle: textStyle),
              if (_.enabledButtons.muteAndSound)
                MuteSoundButton(responsive: responsive),

              if (_.enabledButtons.fullscreen)
                FullscreenButton(
                  responsive: responsive,
                ),
            ],
          ),
        ),
 
      ],
    );
  }
}
