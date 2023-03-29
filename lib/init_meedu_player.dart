import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

Future<void> initMeeduPlayer({bool iosUseMediaKit = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (UniversalPlatform.isWindows ||
  //     UniversalPlatform.isLinux ||
  //     UniversalPlatform.isMacOS) {

  // }

  initVideoPlayerMediaKitIfNeeded(iosUseMediaKit:iosUseMediaKit);
}
