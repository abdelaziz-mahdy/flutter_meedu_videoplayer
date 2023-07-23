import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/video_player_used.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initMeeduPlayer(
    {bool iosUseMediaKit = false,
    bool androidUseMediaKit = false,
    MPVLogLevel logLevel = MPVLogLevel.error}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initWindowManagerIfNeeded();
  if (UniversalPlatform.isDesktop ||
      (iosUseMediaKit && UniversalPlatform.isIOS) ||
      (androidUseMediaKit && UniversalPlatform.isAndroid)) {
    VideoPlayerUsed.mediaKit = true;
  } else {
    VideoPlayerUsed.videoPlayer = true;
  }
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();
  }
  initVideoPlayerMediaKitIfNeeded(
      iosUseMediaKit: iosUseMediaKit,
      androidUseMediaKit: androidUseMediaKit,
      logLevel: logLevel);
}

Future<void> initWindowManagerIfNeeded() async {
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 700),
      center: true,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
