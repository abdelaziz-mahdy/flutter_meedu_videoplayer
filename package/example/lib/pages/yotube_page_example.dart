import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class Quality {
  final String url, label;
  Quality({
    required this.url,
    required this.label,
  });
}

class CorsBypassClient extends http.BaseClient {
  final _client = http.Client();

  @override
  Future<http.StreamedResponse> send(covariant http.Request request) {
    final uri = request.url;
    final http.BaseRequest newRequest = http.Request(
        request.method,
        request.url.replace(
            //TODO: change this cors-anywhere to your instance
            host: '',
            pathSegments: [uri.host, ...uri.pathSegments]))
      ..headers.addAll({
        ...request.headers,
        'origin': 'https://www.youtube.com',
        'x-requested-with': 'https://www.youtube.com',
      })
      ..bodyBytes = request.bodyBytes;

    return _client.send(newRequest);
  }
}

class YoutubeExamplePage extends StatefulWidget {
  const YoutubeExamplePage({Key? key}) : super(key: key);

  @override
  State<YoutubeExamplePage> createState() => _YoutubeExamplePageState();
}

class _YoutubeExamplePageState extends State<YoutubeExamplePage> {
  final _controller = MeeduPlayerController(
      screenManager: const ScreenManager(forceLandScapeInFullscreen: false),
      enabledButtons: const EnabledButtons(rewindAndfastForward: false),
      responsive: Responsive(buttonsSizeRelativeToScreen: 3));
  String fileName = "";
  final List<Quality> _qualities = [];

  /// listener for the video quality
  final ValueNotifier<Quality?> _quality = ValueNotifier(null);

  final ValueNotifier<bool> _loading = ValueNotifier(false);

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
    _currentPositionSubs?.cancel();
    super.dispose();
  }

  Future<void> getYoutubeStreamUrl(String youtubeUrl) async {
    YoutubeExplode yt = YoutubeExplode();
    if (kIsWeb) {
      yt = YoutubeExplode(YoutubeHttpClient(CorsBypassClient()));
    }

    Video video = await yt.videos.get(youtubeUrl);

    StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(video.id);
    if (video.isLive) {
      // MuxedStreamInfo  streamInfo = manifest.muxed.withHighestBitrate();

      _qualities.add(Quality(
          url: await yt.videos.streamsClient.getHttpLiveStreamUrl(video.id),
          label: "Live"));
    } else {
      for (var element in manifest.muxed) {
        _qualities.add(
            Quality(url: element.url.toString(), label: element.qualityLabel));
      }
    }
    if (_qualities.isEmpty) {
      throw Exception("No videos available");
    }
    _qualities.sort(
      (a, b) {
        return b.label.compareTo(a.label);
      },
    );
    // print('streamInfo ${streamInfo.url}');
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

  _playYoutubeVideo(String youtubeUrl) async {
    await getYoutubeStreamUrl(youtubeUrl);

    _quality.value = _qualities[0];
    print(_quality.value!.url);
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
              Navigator.maybePop(context);
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
                    decoration: const InputDecoration(hintText: "Youtube Url"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: _loading,
                      builder: (context, bool loading, child) {
                        return loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  _loading.value = true;
                                  _controller.pause();

                                  _qualities.clear();
                                  _quality.value = null;
                                  _currentPosition = Duration.zero;

                                  try {
                                    await _playYoutubeVideo(url.text);
                                  } catch (e) {
                                    print(e);
                                  }

                                  _loading.value = false;
                                },
                                child: const Text("Play"));
                      }),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: MeeduVideoPlayer(
                  controller: _controller,
                  bottomRight: (ctx, controller, responsive) {
                    // creates a responsive fontSize using the size of video container
                    final double fontSize = responsive.fontSize();

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
                              fontSize: fontSize,
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
          ],
        ),
      ),
    );
  }
}
