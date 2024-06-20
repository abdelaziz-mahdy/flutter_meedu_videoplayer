import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class BasicExampleWithLoopingPage extends StatefulWidget {
  const BasicExampleWithLoopingPage({Key? key}) : super(key: key);

  @override
  State<BasicExampleWithLoopingPage> createState() =>
      _BasicExampleWithLoopingPageState();
}

class _BasicExampleWithLoopingPageState
    extends State<BasicExampleWithLoopingPage> {
  final _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.primary,
      enabledControls: const EnabledControls(doubleTapToSeek: false));

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
              "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
        ),
        autoplay: true,
        looping: true);
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
