import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class BottomControlsExamplePage extends StatefulWidget {
  const BottomControlsExamplePage({Key? key}) : super(key: key);

  @override
  State<BottomControlsExamplePage> createState() =>
      _BottomControlsExamplePageState();
}

class _BottomControlsExamplePageState extends State<BottomControlsExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
      controlsEnabled: false,
      enabledOverlays: const EnabledOverlays(volume: false),
      responsive: Responsive(maxButtonsSize: 30, maxFontSize: 16));

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

    ///use this stream to listen the player data events like completed, playing, paused
    _playerEventSubs =
        _meeduPlayerController.onPlayerStatusChanged.listen((event) {
      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: MeeduVideoPlayer(
                controller: _meeduPlayerController,
              ),
            ),
            SizedBox(
              height: 90,
              child: MeeduPlayerProvider(
                  controller: _meeduPlayerController, child: const Controls()),
            )
          ],
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = MeeduPlayerController.of(context);
    final responsive = controller.responsive;
    controller.responsive.setDimensions(
      context.width,
      context.height,
    );

    print("responsive.width ${responsive.width}");
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: responsive.fontSize(),
    );
    return Container(
      color: Colors.blueGrey.shade900,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Transform.translate(
            offset: const Offset(0, 4),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: PlayerSlider(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    PlayPauseButton(
                      size: responsive.buttonSize(),
                    ),
                    const SizedBox(width: 5),

                    // START VIDEO DURATION
                    RxBuilder(
                      (__) => Text(
                        "${controller.duration.value.inMinutes >= 60 ? printDurationWithHours(controller.position.value) : printDuration(controller.position.value)}/${controller.duration.value.inMinutes >= 60 ? printDurationWithHours(controller.duration.value) : printDuration(controller.duration.value)}",
                        style: textStyle,
                      ),
                    ),

                    // START VIDEO DURATION

                    if (controller.enabledButtons.muteAndSound)
                      SizedBox(
                        width: responsive.wp(40),
                        height: 40,
                        child: RxBuilder(
                          (__) => Row(
                            children: [
                              MuteSoundButton(responsive: responsive),
                              if (!controller.mute.value)
                                Slider(
                                  value: controller.volume.value,
                                  onChanged: (value) =>
                                      controller.setVolume(value),
                                ),
                            ],
                          ),
                        ),
                      ),
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
          ),
        ],
      ),
    );
  }
}
