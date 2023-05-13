import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PrimaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryBottomControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: responsive.fontSize(),
    );
    Widget durationControls = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const SizedBox(width: 10),
            const Expanded(
              child: PlayerSlider(),
            ),
            const SizedBox(width: 10),
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
          ]),
    );
    // END VIDEO DURATION
    Widget otherControls =
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      if (_.bottomRight != null) ...[_.bottomRight!, const SizedBox(width: 5)],
      if (_.enabledButtons.pip) PipButton(responsive: responsive),
      if (_.enabledButtons.videoFit) VideoFitButton(responsive: responsive),
      if (_.enabledButtons.playBackSpeed)
        PlayBackSpeedButton(responsive: responsive, textStyle: textStyle),
      if (_.enabledButtons.muteAndSound)
        MuteSoundButton(responsive: responsive),
      if (_.enabledButtons.fullscreen)
        FullscreenButton(
          size: responsive.buttonSize(),
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
