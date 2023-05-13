import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class CustomControlsExamplePage extends StatefulWidget {
  const CustomControlsExamplePage({Key? key}) : super(key: key);

  @override
  State<CustomControlsExamplePage> createState() =>
      _CustomControlsExamplePageState();
}

class _CustomControlsExamplePageState extends State<CustomControlsExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.custom,
      enabledOverlays: const EnabledOverlays(volume: false));

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
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
            customControls: (context, controller, responsive) {
              final textStyle = TextStyle(
                color: Colors.white,
                fontSize: responsive.fontSize(),
              );

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
                              child: RxBuilder(
                                (__) => Row(
                                  children: [
                                    Expanded(
                                        child: MuteSoundButton(
                                            responsive: responsive)),
                                    !controller.mute.value
                                        ? Expanded(
                                            flex: 2,
                                            child: Slider(
                                              value: controller.volume.value,
                                              onChanged: (value) =>
                                                  controller.setVolume(value),
                                            ),
                                          )
                                        : const Expanded(
                                            flex: 2,
                                            child: SizedBox(),
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
