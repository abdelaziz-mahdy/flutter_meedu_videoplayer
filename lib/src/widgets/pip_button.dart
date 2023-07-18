import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PipButton extends StatelessWidget {
  final Responsive responsive;
  const PipButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
        // observables: [
        //   _.pipAvailable,
        //   _.fullscreen,
        // ],
        (__) {
      if (!_.pipAvailable.value) return Container();
      String iconPath = 'assets/icons/picture-in-picture.png';
      Widget? customIcon = _.customIcons.pip;
      if (_.isInPipMode.value) {
        iconPath = 'assets/icons/exit_picture-in-picture.png';
        customIcon = _.customIcons.exitPip;
      }
      return PlayerButton(
        size: responsive.buttonSize(),
        circle: false,
        backgroundColor: Colors.transparent,
        iconColor: Colors.white,
        iconPath: iconPath,
        customIcon: customIcon,
        onPressed: () =>
            _.isInPipMode.value ? _.closePip(context) : _.enterPip(context),
      );
    });
  }
}
