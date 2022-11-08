import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class MeeduPlayerFullscreenPage extends StatefulWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerFullscreenPage({Key? key, required this.controller})
      : super(key: key);

  @override
  _MeeduPlayerFullscreenPageState createState() =>
      _MeeduPlayerFullscreenPageState();
}

class _MeeduPlayerFullscreenPageState extends State<MeeduPlayerFullscreenPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: RxBuilder(
        //observables: [controller.videoFit],
        (__) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: widget.controller.videoFit.value,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: MeeduVideoPlayer(
                  controller: widget.controller,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    print("disposed");
    widget.controller.videoPlayerToggleFromFullScreen();
    super.dispose();
  }
}
