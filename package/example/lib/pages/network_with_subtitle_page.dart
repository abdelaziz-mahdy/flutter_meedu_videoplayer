import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class NetworkWithSubtitlesPage extends StatefulWidget {
  const NetworkWithSubtitlesPage({Key? key}) : super(key: key);

  @override
  State<NetworkWithSubtitlesPage> createState() =>
      _NetworkWithSubtitlesPageState();
}

class _NetworkWithSubtitlesPageState extends State<NetworkWithSubtitlesPage> {
  late MeeduPlayerController _controller;

  final ValueNotifier<bool> _subtitlesEnabled = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _controller = MeeduPlayerController(
        controlsStyle: ControlsStyle.primary,
        enabledControls: const EnabledControls(doubleTapToSeek: false));
    _setDataSource();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _setDataSource() async {
    await _controller.setDataSource(
      DataSource(
        source:
            'https://thepaciellogroup.github.io/AT-browser-tests/video/ElephantsDream.mp4',
        type: DataSourceType.network,
        closedCaptionFile: _loadCaptions(),
      ),
      autoplay: true,
    );
    _controller.onClosedCaptionEnabled(true);
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    // you can get the fileContents as string from a remote str file using a http client like dio or http
    // or you can load from assets
    /*
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/captions.srt');
    */
    // in srt format
    const String fileContents = '''
0
00:00:02,170 --> 00:00:04,136
Emo, close your eyes

1
00:00:04,136 --> 00:00:05,597
Why?
NOW!

2
00:00:05,597 --> 00:00:07,405
Ok

3
00:00:07,405 --> 00:00:08,803
Good

4
00:00:08,803 --> 00:00:11,541
What do you see at your left side Emo?

5
00:00:11,541 --> 00:00:13,287
Well?

6
00:00:13,287 --> 00:00:16,110
Er nothing?
Really?

7
00:00:16,110 --> 00:00:18,514
No, nothing at all!

8
00:00:18,514 --> 00:00:22,669
Really? and at your right? What do you see at your right side Emo?

9
00:00:22,669 --> 00:00:26,111
Umm, the same Proog

10
00:00:26,111 --> 00:00:28,646
Exactly the same! Nothing!

11
00:00:28,646 --> 00:00:30,794
Great
    ''';
    return SubRipCaptionFile(fileContents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: MeeduVideoPlayer(
          controller: _controller,
          bottomRight: (ctx, controller, responsive) {
            // creates a responsive fontSize using the size of video container
            final double fontSize = responsive.ip(3);

            return CupertinoButton(
              padding: const EdgeInsets.all(5),
              minSize: 25,
              child: ValueListenableBuilder(
                valueListenable: _subtitlesEnabled,
                builder: (BuildContext context, bool enabled, _) {
                  return Text(
                    "CC",
                    style: TextStyle(
                      fontSize: fontSize > 18 ? 18 : fontSize,
                      color: Colors.white.withOpacity(
                        enabled ? 1 : 0.4,
                      ),
                    ),
                  );
                },
              ),
              onPressed: () {
                _subtitlesEnabled.value = !_subtitlesEnabled.value;
                _controller.onClosedCaptionEnabled(_subtitlesEnabled.value);
              },
            );
          },
        ),
      ),
    );
  }
}
