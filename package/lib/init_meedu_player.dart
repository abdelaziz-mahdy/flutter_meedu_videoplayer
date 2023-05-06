import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

Future<void> initMeeduPlayer(
    {bool iosUseMediaKit = false, bool androidUseMediaKit = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  initVideoPlayerMediaKitIfNeeded(
      iosUseMediaKit: iosUseMediaKit, androidUseMediaKit: androidUseMediaKit);
}
