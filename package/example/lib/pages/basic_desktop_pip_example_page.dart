import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class BasicDesktopPipExamplePage extends StatefulWidget {
  const BasicDesktopPipExamplePage({Key? key}) : super(key: key);

  @override
  State<BasicDesktopPipExamplePage> createState() =>
      _BasicDesktopPipExamplePageState();
}

class _BasicDesktopPipExamplePageState
    extends State<BasicDesktopPipExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
    enabledButtons: const EnabledButtons(pip: true),
    // enabledControls: const EnabledControls(doubleTapToSeek: false),
    pipEnabled: true,
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

  _init() async {
    await _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source:
            "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov",
      ),
      autoplay: true,
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: DragToMoveArea(
        child: SizedBox(
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
