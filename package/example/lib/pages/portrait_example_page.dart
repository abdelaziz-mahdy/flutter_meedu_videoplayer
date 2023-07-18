import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/bar.dart';
import 'package:flutter_meedu_videoplayer/forward_and_rewind.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PortraitExamplePage extends StatefulWidget {
  const PortraitExamplePage({Key? key}) : super(key: key);

  @override
  State<PortraitExamplePage> createState() => _PortraitExamplePageState();
}

class _PortraitExamplePageState extends State<PortraitExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.primary,
      enabledControls: const EnabledControls(doubleTapToSeek: false),
      responsive: Responsive(buttonsSizeRelativeToScreen: 6),
      forwardAndRewindStyle: const ForwardAndRewindStyle(bar:BarStyle.progress(height: 8,dotSize: 12,dot: Colors.red,color: Colors.red)),
  );

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _playerEventSubs?.cancel();
    _meeduPlayerController.dispose();
    super.dispose();
  }

  _init() {
    _meeduPlayerController.setDataSource(
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
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
