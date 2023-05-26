import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayPauseButton extends StatelessWidget {
  final double size;
  const PlayPauseButton({Key? key, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
      //observables: [
      //  _.playerStatus.status,
      //  _.buffered,
      //  _.isBuffering,
      //  _.position
      //],
      (__) {
        // if (_.isBuffering.value) {

        //   return PlayerButton(
        //     onPressed: _.pause,
        //     customIcon: Container(
        //         width: size,
        //         height: size,
        //         padding: EdgeInsets.all(size * 0.25),
        //         child: _.loadingWidget!),
        //   );
        // }

        String iconPath = 'assets/icons/repeat.png';
        Widget? customIcon = _.customIcons.repeat;
        if (_.playerStatus.playing) {
          iconPath = 'assets/icons/pause.png';
          customIcon = _.customIcons.pause;
        } else if (_.playerStatus.paused) {
          iconPath = 'assets/icons/play.png';
          customIcon = _.customIcons.play;
        }
        return PlayerButton(
          backgroundColor: Colors.transparent,
          iconColor: Colors.white,
          onPressed: () {
            if (_.playerStatus.playing) {
              _.pause();
            } else if (_.playerStatus.paused) {
              _.play(hideControls: false);
            } else {
              _.play(repeat: true, hideControls: false);
            }
          },
          size: size,
          iconPath: iconPath,
          customIcon: customIcon,
        );
      },
    );
  }
}
