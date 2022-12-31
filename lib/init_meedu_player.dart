import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:universal_platform/universal_platform.dart';

Future<void> initMeeduPlayer() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (UniversalPlatform.isWindows ||
  //     UniversalPlatform.isLinux ||
  //     UniversalPlatform.isMacOS) {

  // }

  initVideoPlayerDartVlcIfNeeded();
}
