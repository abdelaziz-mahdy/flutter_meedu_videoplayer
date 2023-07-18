import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class SecondaryExamplePage extends StatefulWidget {
  const SecondaryExamplePage({Key? key}) : super(key: key);

  @override
  State<SecondaryExamplePage> createState() => _SecondaryExamplePageState();
}

class _SecondaryExamplePageState extends State<SecondaryExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.secondary,
      enabledButtons: const EnabledButtons(rewindAndfastForward: false));

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
          aspectRatio: 16 / 9,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
