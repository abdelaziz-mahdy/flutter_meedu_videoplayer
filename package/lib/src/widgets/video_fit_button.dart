import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class VideoFitButton extends StatelessWidget {
  final Responsive responsive;
  const VideoFitButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    String iconPath = 'assets/icons/fit.png';
    Widget? customIcon = _.customIcons.videoFit;

    return PlayerButton(
      size: responsive.buttonSize(),
      circle: false,
      backgroundColor: Colors.transparent,
      iconColor: Colors.white,
      iconPath: iconPath,
      customIcon: customIcon,
      onPressed: () {
        _.customDebugPrint("toggleVideoFit");
        _.toggleVideoFit();
      },
    );
  }
}
