import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class NetworkWithMultipleSubtitlesPage extends StatefulWidget {
  const NetworkWithMultipleSubtitlesPage({Key? key}) : super(key: key);

  @override
  State<NetworkWithMultipleSubtitlesPage> createState() =>
      _NetworkWithMultipleSubtitlesPageState();
}

class _NetworkWithMultipleSubtitlesPageState
    extends State<NetworkWithMultipleSubtitlesPage> {
  late MeeduPlayerController _controller;

  final ValueNotifier<bool> _subtitlesEnabled = ValueNotifier(true);
  final ValueNotifier<String> _selectedSubtitle = ValueNotifier("english");

  final ValueNotifier<Map<String, String>> _subtitles = ValueNotifier({
    "english": '''
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
    ''',
    "spanish": '''
0
00:00:02,170 --> 00:00:04,136
Emo, cierra los ojos

1
00:00:04,136 --> 00:00:05,597
¿Por qué?
¡Ahora!

2
00:00:05,597 --> 00:00:07,405
De acuerdo

3
00:00:07,405 --> 00:00:08,803
Bien

4
00:00:08,803 --> 00:00:11,541
¿Qué ves a tu lado izquierdo, Emo?

5
00:00:11,541 --> 00:00:13,287
¿Y bien?

6
00:00:13,287 --> 00:00:16,110
¿Nada?
¿En serio?

7
00:00:16,110 --> 00:00:18,514
¡No, absolutamente nada!

8
00:00:18,514 --> 00:00:22,669
¿En serio? ¿Y a tu derecha? ¿Qué ves a tu lado derecho, Emo?

9
00:00:22,669 --> 00:00:26,111
Hmm, lo mismo, Proog

10
00:00:26,111 --> 00:00:28,646
¡Exactamente lo mismo! ¡Nada!

11
00:00:28,646 --> 00:00:30,794
Genial
'''
  });

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
        closedCaptionFile: _loadCaptions(_selectedSubtitle.value),
      ),
      autoplay: true,
    );
    _controller.onClosedCaptionEnabled(true);
  }

  Future<ClosedCaptionFile> _loadCaptions(String key) async {
    // you can get the fileContents as string from a remote str file using a http client like dio or http
    // or you can load from assets
    /*
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/captions.srt');
    */
    // in srt format
    String fileContents = _subtitles.value[key]!;
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

            return Row(
              children: [
                ValueListenableBuilder(
                    valueListenable: _selectedSubtitle,
                    builder: (BuildContext context, String selectedValue, _) {
                      return DropdownButton<String>(
                        value: selectedValue,
                        dropdownColor: Colors
                            .white, // Set dropdown background color to white
                        style: TextStyle(
                          color:
                              Colors.black, // Set dropdown text color to black
                          fontSize: responsive.fontSize(),
                        ),
                        onChanged: (String? newValue) {
                          _selectedSubtitle.value = newValue!;
                          _controller.setClosedCaptionFile(
                              _loadCaptions(_selectedSubtitle.value));
                        },
                        selectedItemBuilder: (context) =>
                            _subtitles.value.keys.map((key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              style: TextStyle(
                                fontSize: responsive.fontSize(),
                                color: Colors
                                    .white, // Set widget text color to white
                              ),
                            ),
                          );
                        }).toList(),

                        items: _subtitles.value.keys.map((key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              style: TextStyle(
                                fontSize: responsive.fontSize(),
                                color: Colors
                                    .black, // Set widget text color to white
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                CupertinoButton(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
