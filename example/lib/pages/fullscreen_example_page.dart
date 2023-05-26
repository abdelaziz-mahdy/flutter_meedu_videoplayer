import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

const videos = [
  'https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov',
  'https://movietrailers.apple.com/movies/independent/bill-ted-face-the-music/bill-and-ted-face-the-music-trailer-1_h720p.mov',
  'https://movietrailers.apple.com/movies/roadsideattractions/words-on-bathroom-walls/words-on-bathroom-walls-trailer-1_h720p.mov',
  'https://movietrailers.apple.com/movies/independent/alone/alone-trailer-1_h720p.mov',
  'https://movietrailers.apple.com/movies/fox/the-new-mutants/the-new-mutants-trailer-1_h720p.mov',
];

class FullscreenExamplePage extends StatefulWidget {
  const FullscreenExamplePage({Key? key}) : super(key: key);

  @override
  State<FullscreenExamplePage> createState() => _FullscreenExamplePageState();
}

class _FullscreenExamplePageState extends State<FullscreenExamplePage> {
  // final MeeduPlayerController _meeduPlayerController = MeeduPlayerController(
  //   screenManager: ScreenManager(
  //     forceLandScapeInFullscreen: false,
  //     orientations: [
  //       DeviceOrientation.landscapeLeft,
  //       DeviceOrientation.landscapeRight,
  //       DeviceOrientation.portraitDown,
  //       DeviceOrientation.portraitUp,
  //     ],
  //   ),
  // );

  final MeeduPlayerController _meeduPlayerController = MeeduPlayerController(
      colorTheme: Colors.blue,
      enabledButtons: const EnabledButtons(rewindAndfastForward: false));
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  DataSource? _dataSource;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _meeduPlayerController.onFullscreenChanged.listen(
      (bool isFullscreen) {
        if (!isFullscreen) {
          // if the fullscreen page was closed
          _dataSource = null;
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _meeduPlayerController.dispose();
    super.dispose();
  }

  Widget get nextButton {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (_, int index, __) {
        final hasNext = index < videos.length - 1;
        return TextButton(
          onPressed: hasNext
              ? () {
                  currentIndex.value++;
                  _set();
                }
              : null,
          child: Text(
            "NEXT VIDEO",
            style: TextStyle(
              color: Colors.white.withOpacity(hasNext ? 1 : 0.2),
            ),
          ),
        );
      },
    );
  }

  Widget get header {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (_, int index, __) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CupertinoButton(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  // close the fullscreen
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text(
                  videos[index],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _set() async {
    final index = currentIndex.value;
    if (_dataSource == null) {
      // if the player is not launched yet
      _dataSource = DataSource(
        source: videos[index],
        type: DataSourceType.network,
      );

      // launch the player in fullscreen mode
      await _meeduPlayerController.launchAsFullscreen(
        context,
        dataSource: _dataSource!,
        autoplay: true,
        header: header,
        bottomRight: nextButton,
      );
    } else {
      // update the player with new datasource and it doesn't re-launch the player
      await _meeduPlayerController.setDataSource(
        _dataSource!.copyWith(
          source: videos[index],
        ),
        seekTo: Duration.zero,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: List.generate(
          videos.length,
          (index) => ListTile(
            onTap: () {
              currentIndex.value = index;
              _set();
            },
            title: Text("video ${index + 1}"),
          ),
        ),
      ),
    );
  }
}
