import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class CustomControlsExamplePage extends StatefulWidget {
  const CustomControlsExamplePage({Key? key}) : super(key: key);

  @override
  _CustomControlsExamplePageState createState() =>
      _CustomControlsExamplePageState();
}

class _CustomControlsExamplePageState extends State<CustomControlsExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.custom,
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
          aspectRatio: 16 / 9,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
            customControls: (context, controller, responsive) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Transform.translate(
                    offset: const Offset(0, 4),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: PlayerSlider(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          PlayPauseButton(
                            size: responsive.buttonSize(),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                      Row(
                        children: [
                          if (controller.bottomRight != null) ...[
                            controller.bottomRight!,
                            const SizedBox(width: 10)
                          ],
                          if (controller.enabledButtons.videoFit)
                            VideoFitButton(responsive: responsive),
                          if (controller.enabledButtons.muteAndSound)
                            MuteSoundButton(responsive: responsive),
                          if (controller.enabledButtons.fullscreen) ...[
                            FullscreenButton(
                              size: responsive.buttonSize(),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ],
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
