import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:wakelock/wakelock.dart';

class PlayerWithHeaderPage extends StatefulWidget {
  const PlayerWithHeaderPage({Key? key}) : super(key: key);

  @override
  State<PlayerWithHeaderPage> createState() => _PlayerWithHeaderPageState();
}

class _PlayerWithHeaderPageState extends State<PlayerWithHeaderPage> {
  final MeeduPlayerController _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.secondary, manageWakeLock: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    // The next line disables the wakelock again.
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
            header: (ctx, controller, responsive) {
              // creates a responsive fontSize using the size of video container
              final double fontSize = responsive.ip(3);

              return Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.black12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Insert you title 3",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize > 17 ? 17 : fontSize,
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        CupertinoIcons.share,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              );
            },
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
