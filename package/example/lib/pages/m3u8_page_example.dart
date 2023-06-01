import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as dio;

Future<String> getConvertFilesNameToLinks(
    {String link = "", String content = "", bool video = true}) async {
  final RegExp regExpListOfLinks =
      RegExp("#EXTINF:.+?\n+(.+)", multiLine: true, caseSensitive: false);

  final RegExp netRegxUrl = RegExp(r'^(http|https):\/\/([\w.]+\/?)\S*');

  Map<String, List<String?>> downloadLinks = {};
  List<RegExpMatch> ListOfLinks =
      regExpListOfLinks.allMatches(content).toList();
  String baseUrl = link;
  String mappingKey = video ? "video" : "audio";
  content = content.replaceAllMapped(regExpListOfLinks, (e) {
    final bool isNetwork = netRegxUrl.hasMatch(e.group(1) ?? "");
    if (isNetwork) {
      return e.group(1)!;
    } else {
      return "${baseUrl.substring(0, baseUrl.lastIndexOf('/'))}/${e.group(1) ?? ""}";
    }
  });
  downloadLinks[mappingKey] = ListOfLinks.map((e) {}).toList();
  return content;
}

Future<List<Quality>> fromM3u8PlaylistUrl(
  String m3u8, {
  String initialSubtitle = "",
  String Function(String quality)? formatter,
  bool descending = true,
  Map<String, String>? httpHeaders,
}) async {
//REGULAR EXPRESIONS//
  final RegExp netRegxUrl = RegExp(r'^(http|https):\/\/([\w.]+\/?)\S*');
  final RegExp netRegx2 = RegExp(r'(.*)\r?\/');
  final RegExp regExpPlaylist = RegExp(
    r"#EXT-X-STREAM-INF:(?:.*,RESOLUTION=(\d+x\d+))?,?(.*)\r?\n(.*)",
    caseSensitive: false,
    multiLine: true,
  );
  final RegExp regExpAudio = RegExp(
    r"""^#EXT-X-MEDIA:TYPE=AUDIO(?:.*,URI="(.*m3u8[^"]*)")""",
    caseSensitive: false,
    multiLine: true,
  );

//GET m3u8 file
  late String content = "";
  final dio.Response response = await dio.Dio().get(
    m3u8,
    options: dio.Options(
      headers: httpHeaders,
      followRedirects: true,
      receiveDataWhenStatusError: true,
    ),
  );
  // await Get.find<SearchEngine>().loadLink(m3u8, headers: httpHeaders);
  if (response.statusCode == 200) {
    content = response.data;
  }
  final String? directoryPath;
  if (kIsWeb) {
    directoryPath = null;
  } else {
    directoryPath = (await getTemporaryDirectory()).path;
  }

//Find matches
  List<RegExpMatch> playlistMatches =
      regExpPlaylist.allMatches(content).toList();
  List<RegExpMatch> audioMatches = regExpAudio.allMatches(content).toList();
  Map<String, dynamic> sources = {};
  Map<String, String> sourceUrls = {};
  final List<String> audioUrls = [];
  if (playlistMatches.isEmpty) {}
  for (int i = 0; i < playlistMatches.length; i++) {
    RegExpMatch playlistMatch = playlistMatches[i];
    final RegExpMatch? playlist = netRegx2.firstMatch(m3u8);
    final String sourceURL = (playlistMatch.group(3)).toString();
    final String quality = (playlistMatch.group(1)).toString();
    final bool isNetwork = netRegxUrl.hasMatch(sourceURL);
    String playlistUrl = sourceURL;

    if (!isNetwork) {
      final String? dataURL = playlist!.group(0);
      playlistUrl = "$dataURL$sourceURL";
    }
//Find audio url
    for (final RegExpMatch audioMatch in audioMatches) {
      final String audio = (audioMatch.group(1)).toString();
      final bool isNetwork = netRegxUrl.hasMatch(audio);
      final RegExpMatch? match = netRegx2.firstMatch(playlistUrl);
      String audioUrl = audio;

      if (!isNetwork && match != null) {
        audioUrl = "${match.group(0)}$audio";
      }
      audioUrls.add(audioUrl);
    }

    final String audioMetadata;
    if (audioUrls.isNotEmpty) {
      if (i < audioUrls.length) {
        //talker.info("using $i audio");
        audioMetadata =
            """#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-medium",NAME="audio-medium",AUTOSELECT=YES,DEFAULT=YES,CHANNELS="2",URI="${audioUrls[i]}"\n""";
      } else {
        //talker.info("using last audio");
        audioMetadata =
            """#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-medium",NAME="audio-medium",AUTOSELECT=YES,DEFAULT=YES,CHANNELS="2",URI="${audioUrls.last}"\n""";
      }
    } else {
      audioMetadata = "";
    }

    if (directoryPath != null) {
      final File file = File(path.join(directoryPath, 'hls$quality.m3u8'));
      file.writeAsStringSync(
        """#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-INDEPENDENT-SEGMENTS\n$audioMetadata#EXT-X-STREAM-INF:CLOSED-CAPTIONS=NONE,BANDWIDTH=1469712,RESOLUTION=$quality,AUDIO="audio-medium",GROUP-ID="audio-medium",FRAME-RATE=30.000\n$playlistUrl""",
      );

      sources[quality] = file;
    } else {
      sourceUrls[quality] = playlistUrl;
    }
  }
  List<Quality> Qualities = [];
  addAutoSource() async {
    final File file = File(path.join(directoryPath!, 'hls_Auto.m3u8'));
    file.writeAsStringSync(
      await getConvertFilesNameToLinks(link: m3u8, content: content),
    );
    Qualities.add(Quality(
      label: "Auto",
      isFile: true,
      file: file,
      httpHeaders: httpHeaders,
    ));
  }

  //if (descending) addAutoSource();

  for (String key in sources.keys) {
    //talker.info(key);
    //talker.info(sources[key].readAsStringSync());
    Qualities.add(Quality(
      label: key,
      file: sources[key]!,
      isFile: true,
      httpHeaders: httpHeaders,
    ));
  }
  for (String key in sourceUrls.keys) {
    Qualities.add(Quality(
      label: key,
      url: sourceUrls[key]!,
      isFile: false,
      httpHeaders: httpHeaders,
    ));
  }

  //await addAutoSource();
  Qualities.add(Quality(
    label: "Auto",
    url: m3u8,
    httpHeaders: httpHeaders,
  ));
  return Qualities;
}

class Quality {
  String url, label;
  Map<String, String>? httpHeaders;
  bool isFile = false;
  File? file;
  Quality(
      {this.url = "",
      this.label = "",
      this.httpHeaders,
      this.isFile = false,
      this.file});
  int quality() {
    if (label.contains("x")) {
      return int.parse(label.split("x")[0]);
    }
    return int.parse(label.replaceAll(RegExp('[^0-9]'), ''));
  }

  int compareTo(Quality other) {
    int epDifference = 0;
    try {
      epDifference = quality().compareTo(other.quality());
    } catch (_) {}
    return epDifference;
  }
}

class M3u8ExamplePage extends StatefulWidget {
  const M3u8ExamplePage({Key? key}) : super(key: key);

  @override
  State<M3u8ExamplePage> createState() => _M3u8ExamplePageState();
}

class _M3u8ExamplePageState extends State<M3u8ExamplePage> {
  final _controller = MeeduPlayerController(
      screenManager: const ScreenManager(forceLandScapeInFullscreen: false),
      enabledButtons: const EnabledButtons(
        rewindAndfastForward: false,
        pip: true,
      ),
      pipEnabled: true,
      responsive: Responsive(buttonsSizeRelativeToScreen: 3));
  String fileName = "";
  List<Quality> _qualities = [];

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

  Future<void> getStreamUrls(String url) async {
    String type;
    Uri parsedLink = Uri.parse(url);
    String path = parsedLink.path;
    String filename = basename(path);
    if (filename.substring(filename.lastIndexOf(".")).contains("?")) {
      type = filename.substring(filename.lastIndexOf("."),
          filename.substring(filename.lastIndexOf(".")).indexOf("?"));
    } else {
      type = filename.substring(filename.lastIndexOf("."));
    }
    if (type == ".m3u8") {
      _qualities = await fromM3u8PlaylistUrl(url);
      _qualities.sort((b, a) => a.compareTo(b));
    } else {
      _qualities.clear();
      _qualities.add(Quality(url: url));
    }
  }

  Future<void> _setDataSource() async {
    // set the data source and play the video in the last video position
    if (_quality.value == null) {
      throw Exception("no Quality selected");
    }
    // print(_quality.value!.file?.readAsStringSync());
    if (_quality.value!.isFile) {
      await _controller.setDataSource(
        DataSource(
          type: DataSourceType.file,
          file: _quality.value!.file,
          httpHeaders: _quality.value!.httpHeaders,
        ),
        autoplay: true,
        seekTo: _currentPosition,
      );
    } else {
      await _controller.setDataSource(
        DataSource(
          type: DataSourceType.network,
          source: _quality.value!.url,
          httpHeaders: _quality.value!.httpHeaders,
        ),
        autoplay: true,
        seekTo: _currentPosition,
      );
    }
  }

  void _onChangeVideoQuality(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: List.generate(
          _qualities.length,
          (index) {
            final quality = _qualities[index];
            return CupertinoActionSheetAction(
              child: Text(
                quality.label,
                style: TextStyle(fontSize: _controller.responsive.fontSize()),
              ),
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

  _playM3u8Video(String url) async {
    await getStreamUrls(url);
    if (_qualities.isEmpty) {
      throw Exception("No videos");
    }
    _quality.value = _qualities[0];
    _setDataSource();
  }

  Widget header(BuildContext context) {
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

  TextEditingController url = TextEditingController(
      text: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("play m3u8 video"),
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
                    decoration: const InputDecoration(hintText: "m3u8 Url"),
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
                                    await _playM3u8Video(url.text);
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
                    final double fontSize = responsive.ip(3);

                    return CupertinoButton(
                      padding: const EdgeInsets.all(5),
                      minSize: 25,
                      onPressed: () {
                        _onChangeVideoQuality(context);
                      },
                      child: ValueListenableBuilder<Quality?>(
                        valueListenable: _quality,
                        builder: (context, Quality? quality, child) {
                          return Text(
                            quality != null ? quality.label : "No qualities",
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
          ],
        ),
      ),
    );
  }
}
