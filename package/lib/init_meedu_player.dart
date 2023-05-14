import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initMeeduPlayer(
    {bool iosUseMediaKit = false, bool androidUseMediaKit = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initWindowManagerIfNeeded();
  initVideoPlayerMediaKitIfNeeded(
      iosUseMediaKit: iosUseMediaKit, androidUseMediaKit: androidUseMediaKit);
}

Future<void> initWindowManagerIfNeeded() async {
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();
  }
}
