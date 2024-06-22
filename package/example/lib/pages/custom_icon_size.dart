import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class CustomSizesExamplePage extends StatefulWidget {
  const CustomSizesExamplePage({Key? key}) : super(key: key);

  @override
  State<CustomSizesExamplePage> createState() => _CustomSizesExamplePageState();
}

class _CustomSizesExamplePageState extends State<CustomSizesExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.primary,
      responsive: Responsive(
        fontSizeRelativeToScreen: 2.5,
        maxFontSize: 16,
        iconsSizeRelativeToScreen: 10,
        maxIconsSize: 100,
        buttonsSizeRelativeToScreen: 10,
        maxButtonsSize: 100,
      ));

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
          aspectRatio: 16 / 9,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
