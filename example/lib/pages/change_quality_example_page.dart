import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class Quality {
  final String url, label;
  Quality({
    required this.url,
    required this.label,
  });
}

class ChangeQualityExamplePage extends StatefulWidget {
  const ChangeQualityExamplePage({Key? key}) : super(key: key);

  @override
  State<ChangeQualityExamplePage> createState() =>
      _ChangeQualityExamplePageState();
}

class _ChangeQualityExamplePageState extends State<ChangeQualityExamplePage> {
  final _controller = MeeduPlayerController(
    screenManager: const ScreenManager(
      forceLandScapeInFullscreen: false,
    ),
  );

  final _qualities = [
    Quality(
      url:
          "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h480p.mov",
      label: "480p",
    ),
    Quality(
      url:
          "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov",
      label: "720p",
    ),
    Quality(
      url:
          "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h1080p.mov",
      label: "1080p",
    ),
  ];

  /// listener for the video quality
  final ValueNotifier<Quality?> _quality = ValueNotifier(null);

  Duration _currentPosition = Duration.zero; // to save the video position

  /// subscription to listen the video position changes
  StreamSubscription? _currentPositionSubs;

  @override
  void initState() {
    super.initState();
    _quality.value = _qualities[0]; // set the default video quality (480p)

    // listen the video position
    _currentPositionSubs = _controller.onPositionChanged.listen(
      (Duration position) {
        _currentPosition = position; // save the video position
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDataSource();
    });
  }

  @override
  void dispose() {
    _currentPositionSubs?.cancel(); // cancel the subscription
    _controller.dispose();
    super.dispose();
  }

  void _onChangeVideoQuality() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: List.generate(
          _qualities.length,
          (index) {
            final quality = _qualities[index];
            return CupertinoActionSheetAction(
              child: Text(quality.label),
              onPressed: () {
                _quality.value = quality; // change the video quality
                _setDataSource(); // update the datasource
                Navigator.pop(_);
              },
            );
          },
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(_),
          isDestructiveAction: true,
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  Future<void> _setDataSource() async {
    // set the data source and play the video in the last video position
    await _controller.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: _quality.value!.url,
      ),
      autoplay: true,
      seekTo: _currentPosition,
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
              onPressed: _onChangeVideoQuality,
              child: ValueListenableBuilder<Quality?>(
                valueListenable: _quality,
                builder: (context, Quality? quality, child) {
                  return Text(
                    quality!.label,
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
