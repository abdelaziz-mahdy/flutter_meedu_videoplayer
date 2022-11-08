import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayBackSpeedExamplePage extends StatefulWidget {
  const PlayBackSpeedExamplePage({Key? key}) : super(key: key);

  @override
  _PlayBackSpeedExamplePageState createState() =>
      _PlayBackSpeedExamplePageState();
}

class _PlayBackSpeedExamplePageState extends State<PlayBackSpeedExamplePage> {
  final _controller = MeeduPlayerController(
    screenManager: const ScreenManager(
      forceLandScapeInFullscreen: false,
    ),
  );

  final ValueNotifier<double> _playbackSpeed = ValueNotifier(1);

  void _onPlaybackSpeed() {
    final options = [0.2, 0.5, 1.0, 2.0, 4.0];
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: List.generate(
          options.length,
          (index) => CupertinoActionSheetAction(
            child: Text("${options[index]}x"),
            onPressed: () {
              _playbackSpeed.value = options[index];
              // change the playback speed
              _controller.setPlaybackSpeed(
                _playbackSpeed.value,
              );
              // hide the modal
              Navigator.pop(_);
            },
          ),
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(_),
          child: const Text("Cancel"),
          isDestructiveAction: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _init() {
    _controller.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source:
            "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4",
      ),
      autoplay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: MeeduVideoPlayer(
          controller: _controller,
          bottomRight: (ctx, controller, responsive) {
            // creates a responsive fontSize using the size of video container
            final double fontSize = responsive.ip(3);

            return CupertinoButton(
              padding: const EdgeInsets.all(5),
              minSize: 25,
              child: ValueListenableBuilder<double>(
                valueListenable: _playbackSpeed,
                builder: (context, double speed, child) {
                  return Text(
                    "$speed x",
                    style: TextStyle(
                      fontSize: fontSize > 18 ? 18 : fontSize,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              onPressed: _onPlaybackSpeed,
            );
          },
        ),
      ),
    );
  }
}
