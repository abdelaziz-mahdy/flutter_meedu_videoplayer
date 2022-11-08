import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';

class PlayBackSpeedButton extends StatefulWidget {
  final Responsive responsive;
  final TextStyle textStyle;
  const PlayBackSpeedButton(
      {Key? key, required this.responsive, required this.textStyle})
      : super(key: key);

  @override
  State<PlayBackSpeedButton> createState() => _PlayBackSpeedButtonState();
}

class _PlayBackSpeedButtonState extends State<PlayBackSpeedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
        //observables: [_.fullscreen],
        (__) {
      return Container(
        decoration: BoxDecoration(
          color: _isHovered ? Colors.grey.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.rectangle,
        ),
        child: TextButton(
          onPressed: () {
            print("s");
            _.togglePlaybackSpeed();
          },
          onHover: (isHovered) {
            setState(() {
              _isHovered = isHovered;
            });
          },
          child: Container(
            padding: EdgeInsets.all(
                widget.responsive.ip(_.fullscreen.value ? 5: 7) * 0.3),
            child: Text(
              _.playbackSpeed.toString(),
              style: widget.textStyle,
            ),
          ),
        ),
      );
    });
  }
}
