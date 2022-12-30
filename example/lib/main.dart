import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer_example/pages/basic_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/change_quality_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/custom_icons_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/disabled_buttons_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/fullscreen_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/listview_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/network_with_subtitle_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/one_page_to_other_page_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/pick_file_page_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/playback_speed_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/player_with_header_page.dart';

void main() {


  initVideoPlayerDartVlcIfNeeded();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        "basic": (_) => BasicExamplePage(),
        "fullscreen": (_) => FullscreenExamplePage(),
        "with-header": (_) => PlayerWithHeaderPage(),
        "subtitles": (_) => NetworkWithSubtitlesPage(),
        "playback-speed": (_) => PlayBackSpeedExamplePage(),
        "quality-change": (_) => ChangeQualityExamplePage(),
        "one-page-to-other": (_) => OnePageExample(),
        "pick-file": (_) => PickFileExamplePage(),
        "custom-icons": (_) => CustomIconsExamplePage(),
        "disabled-buttons": (_) => DisabledButtonsExample(),
        "listview": (_) => ListViewExample(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'basic');
            },
            child: Text("Basic Network example"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'fullscreen');
            },
            child: Text("Fullscreen example"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'with-header');
            },
            child: Text("With header example"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'subtitles');
            },
            child: Text("With subtitles example"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'playback-speed');
            },
            child: Text("Playback speed example"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'quality-change');
            },
            child: Text("Quality Change example"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'one-page-to-other');
            },
            child: Text("One Page to other"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'pick-file');
            },
            child: Text("Pick file"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'custom-icons');
            },
            child: Text("Custom Icons"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'disabled-buttons');
            },
            child: Text("Disabled Buttons"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'listview');
            },
            child: Text("ListView"),
          )
        ],
      ),
    );
  }
}
