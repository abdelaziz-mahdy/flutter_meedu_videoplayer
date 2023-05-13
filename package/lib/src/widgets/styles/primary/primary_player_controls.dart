import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/controls_container.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/primary/bottom_controls.dart';

class PrimaryVideoPlayerControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryVideoPlayerControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);

    return ControlsContainer(
      responsive: responsive,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // RENDER A CUSTOM HEADER
          if (_.header != null)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _.header!,
              ),
            ),
          SizedBox(
            height: responsive.height,
            width: responsive.width,
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_.enabledButtons.rewindAndfastForward) ...[
                PlayerButton(
                  onPressed: _.rewind,
                  size: responsive.iconSize(),
                  iconColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  iconPath: 'assets/icons/rewind.png',
                  customIcon: _.customIcons.rewind,
                ),
                const SizedBox(width: 10),
              ],
              if (_.enabledButtons.playPauseAndRepeat)
                RxBuilder(
                    //observables: [_.showSwipeDuration],
                    //observables: [_.swipeDuration],
                    (__) {
                  _.dataStatus.status.value;
                  if (!_.showSwipeDuration.value &&
                      !_.dataStatus.error &&
                      !_.dataStatus.loading &&
                      !_.isBuffering.value) {
                    return PlayPauseButton(
                      size: responsive.iconSize(),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(responsive.iconSize() * 0.25),
                      child: SizedBox(
                        width: responsive.iconSize(),
                        height: responsive.iconSize(),
                      ),
                    );
                  }
                }),
              if (_.enabledButtons.rewindAndfastForward) ...[
                const SizedBox(width: 10),
                PlayerButton(
                  onPressed: _.fastForward,
                  iconColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  size: responsive.iconSize(),
                  iconPath: 'assets/icons/fast-forward.png',
                  customIcon: _.customIcons.fastForward,
                ),
              ]
            ],
          ),

          PrimaryBottomControls(
            responsive: responsive,
          ),
        ],
      ),
    );
  }
}
