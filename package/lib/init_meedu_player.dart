import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/video_player_used.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

/// Parameters:
/// - `iosUseMediaKit`: A boolean value indicating whether to use media_kit on iOS.
/// - `androidUseMediaKit`: A boolean value indicating whether to use media_kit on Android.
/// - `logLevel`: A `LogLevel` value indicating the desired log level.
/// - `throwErrors`: when playing errors happens, throw error (can be disabled incase of false positives)
Future<void> initMeeduPlayer(
    {bool iosUseMediaKit = false,
    bool androidUseMediaKit = false,
    MPVLogLevel logLevel = MPVLogLevel.error,
    bool throwErrors = true}) async {
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
      logLevel: logLevel,
      throwErrors: throwErrors);
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
