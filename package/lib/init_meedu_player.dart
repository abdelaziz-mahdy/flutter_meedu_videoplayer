import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/src/video_player_used.dart';
import 'package:fvp/fvp.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

/// Parameters:
/// - `iosUseFVP`: A boolean value indicating whether to use fvp on iOS.
/// - `androidUseFVP`: A boolean value indicating whether to use fvp on Android.
Future<void> initMeeduPlayer({
  bool iosUseFVP = false,
  bool androidUseFVP = false,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initWindowManagerIfNeeded();
  if (UniversalPlatform.isDesktop ||
      (iosUseFVP && UniversalPlatform.isIOS) ||
      (androidUseFVP && UniversalPlatform.isAndroid)) {
    registerWith();
    VideoPlayerUsed.fvp = true;
  } else {
    VideoPlayerUsed.videoPlayer = true;
  }
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();
  }
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
