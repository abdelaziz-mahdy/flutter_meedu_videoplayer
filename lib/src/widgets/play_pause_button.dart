import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

import 'player_button.dart';

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
        if (_.isBuffering.value) {
          return CupertinoButton(onPressed: _.pause, child: _.loadingWidget!);
        }

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
          backgrounColor: Colors.transparent,
          iconColor: Colors.white,
          onPressed: () {
            if (_.playerStatus.playing) {
              _.pause();
            } else if (_.playerStatus.paused) {
              _.play();
            } else {
              _.play(repeat: true);
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
