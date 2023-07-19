import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

import 'package:native_device_orientation/native_device_orientation.dart';

class Quality {
  final String url, label;
  Quality({
    required this.url,
    required this.label,
  });
}

class AutoFullScreenExamplePage extends StatefulWidget {
  const AutoFullScreenExamplePage({Key? key}) : super(key: key);

  @override
  State<AutoFullScreenExamplePage> createState() =>
      _AutoFullScreenExamplePageState();
}

class _AutoFullScreenExamplePageState extends State<AutoFullScreenExamplePage> {
  final _controller = MeeduPlayerController(
      colorTheme: Colors.red,
      screenManager: const ScreenManager(hideSystemOverlay: false),
      enabledButtons: const EnabledButtons(rewindAndfastForward: false));

  final _qualities = [
    Quality(
      url:
          "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h480p.mov",
      label: "480p",
    ),
    Quality(
      url:
          "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov",
      label: "720p",
    ),
    Quality(
      url:
          "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h1080p.mov",
      label: "1080p",
    ),
  ];

  /// listener for the video quality
  final ValueNotifier<Quality?> _quality = ValueNotifier(null);

  Duration _currentPosition = Duration.zero; // to save the video position

  /// subscription to listen the video position changes
  StreamSubscription? _currentPositionSubs;

  StreamSubscription<NativeDeviceOrientation>? _orientation;

  /// A timer used to debounce the orientation change event listener.
  Timer? _debounceTimer;

  /// A flag indicating if the device was put in fullscreen mode from an orientation change.
  bool fullScreenFromOrientation = false;

  @override
  void initState() {
    super.initState();

    // Set the default video quality to 480p.
    _quality.value = _qualities[0];

    // Listen to the video position changes and save the current position.
    _currentPositionSubs = _controller.onPositionChanged.listen(
      (Duration position) {
        _currentPosition = position;
      },
    );

    // Set the video source after the frame has been rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDataSource();
    });

    // Listen for device orientation changes.
    _orientation = NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      // Cancel any active debounce timers.
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer?.cancel();
      }

      // Set a new debounce timer to wait 100 milliseconds before processing the orientation change.
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        print("onOrientationChanged $event");

        // Check the device orientation to identify the current mode.
        if (event == NativeDeviceOrientation.portraitUp ||
            event == NativeDeviceOrientation.portraitDown) {
          // Exit fullscreen mode if the device was put in fullscreen mode from an orientation change.
          if (_controller.fullscreen.value && fullScreenFromOrientation) {
            _controller.setFullScreen(false, context);
            fullScreenFromOrientation = false;
          }
        }

        if (event == NativeDeviceOrientation.landscapeLeft ||
            event == NativeDeviceOrientation.landscapeRight) {
          // Enter fullscreen mode if the device is in landscape mode and not in fullscreen mode.
          if (!_controller.fullscreen.value) {
            _controller.setFullScreen(true, context);
            fullScreenFromOrientation = true;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _currentPositionSubs?.cancel(); // cancel the subscription
    _orientation?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChangeVideoQuality() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: List.generate(
          _qualities.length,
          (index) {
            final quality = _qualities[index];
            return CupertinoActionSheetAction(
              child: Text(quality.label),
              onPressed: () {
                _quality.value = quality; // change the video quality
                _setDataSource(); // update the datasource
                Navigator.maybePop(_);
              },
            );
          },
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.maybePop(_),
          isDestructiveAction: true,
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  Future<void> _setDataSource() async {
    // set the data source and play the video in the last video position
    await _controller.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: _quality.value!.url,
      ),
      autoplay: true,
      seekTo: _currentPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test"),
          backgroundColor: Colors.red[100],
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 250,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: MeeduVideoPlayer(
                  controller: _controller,
                  bottomRight: (ctx, controller, responsive) {
                    final double fontSize = responsive.ip(3);
                    return CupertinoButton(
                      padding: const EdgeInsets.all(5),
                      minSize: 25,
                      onPressed: _onChangeVideoQuality,
                      child: ValueListenableBuilder<Quality?>(
                        valueListenable: _quality,
                        builder: (context, Quality? quality, child) {
                          return Text(
                            quality!.label,
                            style: TextStyle(
                              fontSize: fontSize > 18 ? 18 : fontSize,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    10,
                    (index) => ListTile(
                      leading: const Icon(Icons.play_arrow),
                      title: Text('Item $index'),
                      subtitle: Text('Subtitle $index'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(useMaterial3: true),
    darkTheme: ThemeData.dark(useMaterial3: true),
    home: const AutoFullScreenExamplePage(),
  ));
}
