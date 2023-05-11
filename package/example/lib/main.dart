import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer_example/pages/auto_fullscreen_on_rotation.dart';
import 'package:flutter_meedu_videoplayer_example/pages/basic_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/basic_example_with_looping_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/change_quality_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/custom_controls.dart';
import 'package:flutter_meedu_videoplayer_example/pages/custom_icon_size.dart';
import 'package:flutter_meedu_videoplayer_example/pages/custom_icons_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/disabled_buttons_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/fullscreen_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/gridview_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/listview_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/m3u8_page_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/network_with_subtitle_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/one_page_to_other_page_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/only_gestures_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/pick_file_page_example.dart';
import 'package:flutter_meedu_videoplayer_example/pages/playback_speed_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/player_with_header_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/portrait_example_page.dart';
import 'package:flutter_meedu_videoplayer_example/pages/secondary_controls.dart';
import 'package:flutter_meedu_videoplayer_example/pages/yotube_page_example.dart';

void main() {
  initMeeduPlayer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        "basic": (_) => const BasicExamplePage(),
        "basic_with_looping": (_) => const BasicExampleWithLoopingPage(),
        "only_gestures": (_) => const OnlyGesturesExamplePage(),
        "secondary_controls": (_) => const SecondaryExamplePage(),
        "custom_controls": (_) => const CustomControlsExamplePage(),
        "custom_sizes": (_) => const CustomSizesExamplePage(),
        "fullscreen": (_) => const FullscreenExamplePage(),
        "with-header": (_) => const PlayerWithHeaderPage(),
        "subtitles": (_) => const NetworkWithSubtitlesPage(),
        "playback-speed": (_) => const PlayBackSpeedExamplePage(),
        "quality-change": (_) => const ChangeQualityExamplePage(),
        "one-page-to-other": (_) => const OnePageExample(),
        "pick-file": (_) => const PickFileExamplePage(),
        "custom-icons": (_) => const CustomIconsExamplePage(),
        "disabled-buttons": (_) => const DisabledButtonsExample(),
        "listview": (_) => const ListViewExample(),
        "gridview": (_) => const GridViewExample(),
        "portrait": (_) => const PortraitExamplePage(),
        "youtube": (_) => const YoutubeExamplePage(),
        "m3u8": (_) => const M3u8ExamplePage(),
        "auto_fullscreen": (_) => const AutoFullScreenExamplePage(),
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
      // backgroundColor: Colors.grey[500],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Examples Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'Basic Examples',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    buildButton(
                      context,
                      text: 'Basic Network example',
                      routeName: 'basic',
                      description:
                          'An example of how to load a video from a network source.',
                    ),
                    buildButton(
                      context,
                      text: 'Basic Network example with looping',
                      routeName: 'basic_with_looping',
                      description:
                          'An example of how to load a video from a network source with looping enabled.',
                    ),
                    buildButton(
                      context,
                      text:
                          'Network example without rewind and forward buttons',
                      routeName: 'only_gestures',
                      description:
                          'An example of how to load a video from a network source without rewind and forward buttons.',
                    ),
                    buildButton(
                      context,
                      text: 'Secondary Controls',
                      routeName: 'secondary_controls',
                      description:
                          'An example of how to customize the secondary controls of the player.',
                    ),
                    buildButton(
                      context,
                      text: 'Custom Controls',
                      routeName: 'custom_controls',
                      description:
                          'An example of how to create custom controls for the player.',
                    ),
                    buildButton(
                      context,
                      text: 'Custom Sizes',
                      routeName: 'custom_sizes',
                      description:
                          'An example of how to Customize icon and buttons and font sizes for the player.',
                    ),
                  ],
                ),

                // Advanced Examples Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'Advanced Examples',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    buildButton(
                      context,
                      text: 'Fullscreen example',
                      routeName: 'fullscreen',
                      description:
                          'An example of how to enable fullscreen mode for the player.',
                    ),
                    buildButton(
                      context,
                      text: 'With header example',
                      routeName: 'with-header',
                      description:
                          'An example of how to add a header to the player.',
                    ),
                    buildButton(
                      context,
                      text: 'With subtitles example',
                      routeName: 'subtitles',
                      description:
                          'An example of how to add subtitles to the player.',
                    ),
                    buildButton(
                      context,
                      text: 'Playback speed example',
                      routeName: 'playback-speed',
                      description:
                          'An example of how to change the playback speed of the video.',
                    ),
                    buildButton(
                      context,
                      text: 'Quality Change example',
                      routeName: 'quality-change',
                      description:
                          'An example of how to change the quality of the video.',
                    ),
                    buildButton(
                      context,
                      text: 'One Page to other',
                      routeName: 'one-page-to-other',
                      description:
                          'An example of how to navigate between pages in the app.',
                    ),
                    kIsWeb
                        ? buildDisabledButton(
                            context,
                            text: "Pick file Example doesn't work on web",
                            description:
                                'This example is not available on web due to restrictions.',
                          )
                        : buildButton(
                            context,
                            text: 'Pick file',
                            routeName: 'pick-file',
                            description:
                                'An example of how to pick a video file from the device storage.',
                          ),
                    buildButton(
                      context,
                      text: 'Custom Icons',
                      routeName: 'custom-icons',
                      description:
                          'An example of how to use custom icons for the player controls.',
                    ),
                    buildButton(
                      context,
                      text: 'Disabled Buttons',
                      routeName: 'disabled-buttons',
                      description:
                          'An example of how to disable certain buttons in the player controls.',
                    ),
                    buildButton(
                      context,
                      text: 'Portrait',
                      routeName: 'portrait',
                      description:
                          'An example of how to lock the player in portrait mode.',
                    ),
                    buildButton(
                      context,
                      text: 'Auto FullScreen on rotation',
                      routeName: 'auto_fullscreen',
                      description:
                          'Automatically switch to fullscreen mode when device is rotated.',
                    ),
                    kIsWeb
                        ? buildDisabledButton(
                            context,
                            text: "Youtube Example doesn't work on web",
                            description:
                                'This example is not available on web due to restrictions.',
                          )
                        : buildButton(
                            context,
                            text: 'Youtube',
                            routeName: 'youtube',
                            description: 'Play a Youtube video.',
                          ),
                    buildButton(
                      context,
                      text: 'M3u8 with qualities',
                      routeName: 'm3u8',
                      description:
                          'Play a HLS stream with the ability to change qualities.',
                    ),
                  ],
                ),
                // List/Grid View Examples Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'List/Grid View Examples',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(children: [
                  buildButton(
                    context,
                    text: 'ListView',
                    routeName: 'listview',
                    description:
                        'An example of how to display a list of videos using a ListView widget.',
                  ),
                  buildButton(
                    context,
                    text: 'GridView',
                    routeName: 'gridview',
                    description:
                        'An example of how to display a grid of videos using a GridView widget.',
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context,
      {required String text,
      required String description,
      required String routeName}) {
    return Card(
      elevation: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 8.0),
              Text(description, style: const TextStyle(fontSize: 14.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDisabledButton(BuildContext context,
      {required String text, required String description}) {
    return Card(
      elevation: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.red, fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
