import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class ClosedCaptionView extends StatelessWidget {
  final Responsive responsive;
  final double distanceFromBottom;

  ///[customCaptionView] when a custom view for the captions is needed
  final Widget Function(BuildContext context, MeeduPlayerController controller,
      Responsive responsive, String text)? customCaptionView;
  const ClosedCaptionView(
      {Key? key,
      required this.responsive,
      this.distanceFromBottom = 30,
      this.customCaptionView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
        //observables: [_.closedCaptionEnabled],
        (__) {
      if (!_.closedCaptionEnabled.value) return Container();

      return StreamBuilder<Duration>(
        initialData: Duration.zero,
        stream: _.onPositionChanged,
        builder: (__, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          final strSubtitle = _.videoPlayerController!.value.caption.text;

          return Positioned(
            left: 60,
            right: 60,
            bottom: distanceFromBottom,
            child: customCaptionView != null
                ? customCaptionView!(context, _, responsive, strSubtitle)
                : ClosedCaption(
                    text: strSubtitle,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.fontSize(),
                    ),
                  ),
          );
        },
      );
    });
  }
}
