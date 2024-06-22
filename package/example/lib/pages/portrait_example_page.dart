import 'dart:async';

import 'package:flutter/material.dart';
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
      responsive: Responsive(buttonsSizeRelativeToScreen: 6));

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
