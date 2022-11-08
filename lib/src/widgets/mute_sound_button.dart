import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

import 'package:flutter_meedu/ui.dart';

import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';

import 'player_button.dart';

class MuteSoundButton extends StatelessWidget {
  final Responsive responsive;
  const MuteSoundButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
        //observables: [_.mute, _.fullscreen],
        (__) {
      String iconPath = 'assets/icons/mute.png';
      Widget? customIcon = _.customIcons.mute;

      if (!_.mute.value) {
        iconPath = 'assets/icons/sound.png';
        customIcon = _.customIcons.sound;
      }

      return PlayerButton(
        size: responsive.ip(_.fullscreen.value ? 4 : 6),
        circle: false,
        backgrounColor: Colors.transparent,
        iconColor: Colors.white,
        iconPath: iconPath,
        customIcon: customIcon,
        onPressed: () {
          _.setMute(!_.mute.value);
        },
      );
    });
  }
}
