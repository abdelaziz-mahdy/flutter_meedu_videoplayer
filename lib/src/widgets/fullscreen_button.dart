import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';

import 'player_button.dart';

class FullscreenButton extends StatelessWidget {
  final Responsive responsive;
  const FullscreenButton({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
      //observables: [_.fullscreen],
      (__) {
        String iconPath = 'assets/icons/minimize.png';
        Widget? customIcon = _.customIcons.minimize;

        if (!_.fullscreen.value) {
          iconPath = 'assets/icons/fullscreen.png';
          customIcon = _.customIcons.fullscreen;
        }
        return PlayerButton(
          size: responsive.ip(_.fullscreen.value ? 4: 6),
          circle: false,
          backgrounColor: Colors.transparent,
          iconColor: Colors.white,
          iconPath: iconPath,
          customIcon: customIcon,
          onPressed: () {
            if (_.fullscreen.value) {
              Navigator.pop(context);
            } else {
              _.goToFullscreen(context);
            }
            // }
          },
        );
      },
    );
  }
}
