import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayBackSpeedExamplePage extends StatefulWidget {
  const PlayBackSpeedExamplePage({Key? key}) : super(key: key);

  @override
  State<PlayBackSpeedExamplePage> createState() =>
      _PlayBackSpeedExamplePageState();
}

class _PlayBackSpeedExamplePageState extends State<PlayBackSpeedExamplePage> {
  final _controller = MeeduPlayerController(
      screenManager: const ScreenManager(
        forceLandScapeInFullscreen: false,
      ),
      enabledControls: const EnabledControls(doubleTapToSeek: false));

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
          isDestructiveAction: true,
          child: const Text("Cancel"),
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
            "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov",
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
              onPressed: _onPlaybackSpeed,
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
            );
          },
        ),
      ),
    );
  }
}
