import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/utils.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/fullscreen_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/mute_sound_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/play_pause_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/player_slider.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/video_fit_button.dart';

class SecondaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const SecondaryBottomControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    final fontSize = responsive.ip(2);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize > 15 ? 15 : fontSize,
    );

    final tmp = responsive.ip(8);
    final buttonsSize = tmp < 40.0 ? tmp : 40.0;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, 4),
            child: const PlayerSlider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  PlayPauseButton(
                    size: buttonsSize,
                  ),
                  const SizedBox(width: 5),
                  RxBuilder(
                    //observables: [_.duration, _.position],
                    (__) {
                      String text = "";
                      if (_.duration.value.inMinutes >= 60) {
                        // if the duration is >= 1 hour
                        text =
                            "${printDurationWithHours(_.position.value)} / ${printDurationWithHours(_.duration.value)}";
                      } else {
                        text =
                            "${printDuration(_.position.value)} / ${printDuration(_.duration.value)}";
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          text,
                          style: textStyle,
                        ),
                      );
                    },
                  ),
                  // PlayerButton(
                  //   onPressed: _.rewind,
                  //   size: buttonsSize,
                  //   iconColor: Colors.white,
                  //   backgrounColor: Colors.transparent,
                  //   iconPath: 'assets/icons/rewind.png',
                  // ),
                  // PlayerButton(
                  //   onPressed: _.fastForward,
                  //   iconColor: Colors.white,
                  //   backgrounColor: Colors.transparent,
                  //   size: buttonsSize,
                  //   iconPath: 'assets/icons/fast-forward.png',
                  // ),
                  const SizedBox(width: 5),
                ],
              ),
              Row(
                children: [
                  if (_.bottomRight != null) ...[
                    _.bottomRight!,
                    const SizedBox(width: 10)
                  ],
                  //if (_.enabledButtons.pip) PipButton(responsive: responsive),
                  if (_.enabledButtons.videoFit)
                    VideoFitButton(responsive: responsive),
                  if (_.enabledButtons.muteAndSound)
                    MuteSoundButton(responsive: responsive),
                  if (_.enabledButtons.fullscreen) ...[
                    FullscreenButton(
                      size: buttonsSize,
                    ),
                    const SizedBox(width: 5),
                  ],
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
