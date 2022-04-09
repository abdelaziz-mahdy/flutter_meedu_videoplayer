/*
import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx.dart';

import 'package:anime_here/videoPlayerWidget/src/controller.dart';
import 'package:anime_here/videoPlayerWidget/src/helpers/responsive.dart';

import 'package:anime_here/videoPlayerWidget/meedu_player.dart';

import 'package:anime_here/videoPlayerWidget/src/widgets/player_button.dart';


import 'player_button.dart';

class PipButton extends StatelessWidget {
  final Responsive responsive;
  const PipButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
        observables: [
          _.pipAvailable,
          _.fullscreen,
        ],
        builder: (__) {
          if (!_.pipAvailable.value || !_.showPipButton) return Container();
          return PlayerButton(
            size: responsive.ip(_.fullscreen.value ? 5 : 7),
            circle: false,
            backgrounColor: Colors.transparent,
            iconColor: Colors.white,
            iconPath: 'assets/icons/picture-in-picture.png',
            customIcon: _.customIcons.pip,
            onPressed: () => _.enterPip(context),
          );
        });
  }
}
*/
