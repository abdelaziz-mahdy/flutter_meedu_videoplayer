import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:wakelock/wakelock.dart';

class CustomIconsExamplePage extends StatefulWidget {
  const CustomIconsExamplePage({Key? key}) : super(key: key);

  @override
  State<CustomIconsExamplePage> createState() => _CustomIconsExamplePageState();
}

class _CustomIconsExamplePageState extends State<CustomIconsExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
    manageWakeLock: false,
    // enabledControls: const EnabledControls(doubleTapToSeek: false)
  );

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS wakelock.
    _playerEventSubs = _meeduPlayerController.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          Wakelock.enable();
        } else {
          Wakelock.disable();
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
    Wakelock.disable();
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
            customIcons: (responsive) {
              final iconSize = responsive.ip(15);
              final miniIconSize = responsive.ip(7);
              return CustomIcons(
                play: Container(
                  padding: EdgeInsets.all(iconSize * 0.2),
                  child: Icon(
                    Icons.play_arrow,
                    size: iconSize,
                    color: Colors.redAccent,
                  ),
                ),
                pause: Container(
                  padding: EdgeInsets.all(iconSize * 0.2),
                  child: Icon(
                    Icons.pause,
                    size: iconSize,
                    color: Colors.redAccent,
                  ),
                ),
                rewind: Container(
                  padding: EdgeInsets.all(iconSize * 0.1),
                  child: Icon(
                    Icons.fast_rewind_rounded,
                    size: iconSize * 0.8,
                    color: Colors.redAccent,
                  ),
                ),
                fastForward: Container(
                  padding: EdgeInsets.all(iconSize * 0.1),
                  child: Icon(
                    Icons.fast_forward_rounded,
                    size: iconSize * 0.8,
                    color: Colors.redAccent,
                  ),
                ),
                mute: Container(
                  padding: EdgeInsets.all(miniIconSize * 0.2),
                  child: Icon(
                    Icons.volume_off_rounded,
                    size: miniIconSize,
                    color: Colors.redAccent,
                  ),
                ),
                sound: Container(
                  padding: EdgeInsets.all(miniIconSize * 0.2),
                  child: Icon(
                    Icons.volume_up_rounded,
                    size: miniIconSize,
                    color: Colors.redAccent,
                  ),
                ),
                fullscreen: Container(
                  padding: EdgeInsets.all(miniIconSize * 0.2),
                  child: Icon(
                    Icons.fullscreen_rounded,
                    size: miniIconSize,
                    color: Colors.redAccent,
                  ),
                ),
                minimize: Container(
                  padding: EdgeInsets.all(miniIconSize * 0.2),
                  child: Icon(
                    Icons.fullscreen_exit_rounded,
                    size: miniIconSize,
                    color: Colors.redAccent,
                  ),
                ),
                pip: Container(
                  padding: EdgeInsets.all(miniIconSize * 0.2),
                  child: Icon(
                    Icons.picture_in_picture_alt_rounded,
                    size: miniIconSize * 0.8,
                    color: Colors.redAccent,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
