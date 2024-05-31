import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/bar.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        LayoutBuilder(builder: (ctx, constraints) {
          return RxBuilder(
            //observables: [_.buffered, _.duration],
                (__) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: Colors.white30,
                width: constraints.maxWidth * _.bufferedPercent.value,
                height: 3,
              );
            },
          );
        }),
        RxBuilder(
          //observables: [_.sliderPosition, _.duration],
              (__) {
            final double value =
            _.sliderPosition.value.inMilliseconds.toDouble();
            final double max = _.duration.value.inMilliseconds.toDouble();
            // if (value > max || max <= 0) {
            //   return Container();
            // }
            return Container(
              constraints: const BoxConstraints(
                maxHeight: 30,
              ),
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: MSliderTrackShape(_.forwardAndRewindStyle.bar),
                  thumbColor: _.forwardAndRewindStyle.bar.identifier,
                  activeTrackColor: _.forwardAndRewindStyle.bar.color,
                  trackHeight: _.forwardAndRewindStyle.bar.height,
                  thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: _.forwardAndRewindStyle.bar.thumbRadius),
                ),
                child: Slider(
                  min: 0,
                  divisions: null,
                  value: value,
                  onChangeStart: (v) {
                    _.onChangedSliderStart();
                  },
                  onChangeEnd: (v) {
                    _.onChangedSliderEnd();
                    _.seekTo(
                      Duration(milliseconds: v.floor()),
                    );
                  },
                  label: printDuration(_.sliderPosition.value),
                  max: max,
                  onChanged: _.onChangedSlider,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  final BarStyle bar;
  MSliderTrackShape(this.bar);

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = bar.height;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2 + 4;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
