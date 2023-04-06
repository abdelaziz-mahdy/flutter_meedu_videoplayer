import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Quality {
  final String url, label;
  Quality({
    required this.url,
    required this.label,
  });
}

class YoutubeExamplePage extends StatefulWidget {
  const YoutubeExamplePage({Key? key}) : super(key: key);

  @override
  _YoutubeExamplePageState createState() => _YoutubeExamplePageState();
}

class _YoutubeExamplePageState extends State<YoutubeExamplePage> {
  final _controller = MeeduPlayerController(
    screenManager: const ScreenManager(forceLandScapeInFullscreen: false),
  );
  String fileName = "";
  List<Quality> _qualities = [];

  /// listener for the video quality
  final ValueNotifier<Quality?> _quality = ValueNotifier(null);

  Duration _currentPosition = Duration.zero; // to save the video position

  /// subscription to listen the video position changes
  StreamSubscription? _currentPositionSubs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // listen the video position
    _currentPositionSubs = _controller.onPositionChanged.listen(
      (Duration position) {
        _currentPosition = position; // save the video position
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getYoutubeStreamUrl(String youtubeUrl) async {
    var yt = YoutubeExplode();
    var video = await yt.videos.get(youtubeUrl);

    var manifest = await yt.videos.streamsClient.getManifest(video.id);
    var streamInfo = manifest.muxed.withHighestBitrate();
    manifest.muxed.forEach((element) {
      _qualities.add(
          Quality(url: element.url.toString(), label: element.qualityLabel));
    });
    print('streamInfo ${streamInfo.url}');
    // Close the YoutubeExplode's http client.
    yt.close();
    // return streamInfo.url.toString();
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
                Navigator.pop(_);
              },
            );
          },
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(_),
          isDestructiveAction: true,
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  _playYoutubeVideo(String youtubeUrl) async {
    await getYoutubeStreamUrl(youtubeUrl);
    if (_qualities.isEmpty) {
      throw Exception("No videos available");
    }
    _quality.value = _qualities[0];
    _setDataSource();
    // // ignore: use_build_context_synchronously
    // _controller.launchAsFullscreen(context,
    //     autoplay: true,
    //     dataSource: DataSource(
    //       source: _qualities[],
    //       type: DataSourceType.network,
    //     ),
    //     bottomRight: CupertinoButton(
    //         padding: const EdgeInsets.all(5),
    //         minSize: 25,
    //         onPressed: _onChangeVideoQuality,
    //         child: ValueListenableBuilder<Quality?>(
    //           valueListenable: _quality,
    //           builder: (context, Quality? quality, child) {
    //             return Text(
    //               quality!.label,
    //               style: TextStyle(
    //                 color: Colors.white,
    //               ),
    //             );
    //           },
    //         )),
    //     header: header);
  }

  Widget get header {
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
              fileName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController url = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("play youtube video"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: url,
                    decoration: InputDecoration(hintText: "Youtube Url"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () {
                        _qualities.clear();
                        _quality.value = null;
                        _playYoutubeVideo(url.text);
                      },
                      child: Text("Play")),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: MeeduVideoPlayer(
                controller: _controller,
                bottomRight: (ctx, controller, responsive) {
                  // creates a responsive fontSize using the size of video container
                  final double fontSize = responsive.ip(3);

                  return CupertinoButton(
                    padding: const EdgeInsets.all(5),
                    minSize: 25,
                    onPressed: _onChangeVideoQuality,
                    child: ValueListenableBuilder<Quality?>(
                      valueListenable: _quality,
                      builder: (context, Quality? quality, child) {
                        return Text(
                          quality != null
                              ? quality.label
                              : "No qualities loaded ",
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
          ],
        ),
      ),
    );
  }
}
