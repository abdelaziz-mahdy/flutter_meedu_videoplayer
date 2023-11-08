import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class OnePageExample extends StatefulWidget {
  const OnePageExample({Key? key}) : super(key: key);

  @override
  State<OnePageExample> createState() => _OnePageExampleState();
}

class _OnePageExampleState extends State<OnePageExample> {
  MeeduPlayerController? _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.secondary,
      manageWakeLock: false,
      responsive: Responsive(buttonsSizeRelativeToScreen: 6));

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS WakelockPlus.
    _playerEventSubs = _meeduPlayerController!.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          WakelockPlus.enable();
        } else {
          WakelockPlus.disable();
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _meeduDispose();
    super.dispose();
  }

  Future<void> _meeduDispose() async {
    if (_meeduPlayerController != null) {
      _playerEventSubs?.cancel();
      await _meeduPlayerController!.dispose();
      _meeduPlayerController = null;
      // The next line disables the wakelock again.
      await WakelockPlus.disable();
    }
  }

  _init() {
    _meeduPlayerController!.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: "https://jinyus.github.io/flutter_meedu_videoplayer/assets/sample_360p.mp4",
      ),
      autoplay: true,
    );
  }

  Future<void> _gotTo() async {
    final route = MaterialPageRoute(
      builder: (_) => const PageTwo(),
    );
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page 1"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: MeeduVideoPlayer(
                controller: _meeduPlayerController!,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: TextButton(
                onPressed: _gotTo,
                child: const Text("Page 2"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
  );

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS WakelockPlus.
    _playerEventSubs = _meeduPlayerController.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          WakelockPlus.enable();
        } else {
          WakelockPlus.disable();
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    // The next line disables the wakelock again.
    _playerEventSubs?.cancel();
    WakelockPlus.disable();
    _meeduPlayerController.dispose();
    super.dispose();
  }

  _init() {
    _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: "https://movietrailers.apple.com/movies/fox/the-new-mutants/the-new-mutants-trailer-1_h360p.mov",
      ),
      autoplay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page 2"),
      ),
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
