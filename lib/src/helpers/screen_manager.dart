import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:window_manager/window_manager.dart';

class ScreenManager {
  /// [orientations] the device orientation after exit of the fullscreen
  final List<DeviceOrientation> orientations;

  /// [overlays] the device overlays after exit of the fullscreen
  final List<SystemUiOverlay> overlays;

  /// when the player is in fullscreen mode if forceLandScapeInFullscreen the player only show the landscape mode
  final bool forceLandScapeInFullscreen;

  final bool edgeToedge;

  const ScreenManager(
      {this.orientations = DeviceOrientation.values,
      this.overlays = SystemUiOverlay.values,
      this.forceLandScapeInFullscreen = true,
      this.edgeToedge = false});

  /// set the default orientations and overlays after exit of fullscreen
  Future<void> setDefaultOverlaysAndOrientations() async {
    //await SystemChrome.setPreferredOrientations(this.orientations);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: this.overlays);
    AutoOrientation.portraitAutoMode();
  }

  Future<void> setWindowsFullScreen(bool state, MeeduPlayerController _) async {
    _.fullscreen.value = state;
    print(await windowManager.isFullScreen());
    if (state) {
      windowManager.setFullScreen(state);
    } else {
      windowManager.setFullScreen(state);
      windowManager.restore();
    }
  }

  Future<void> setOverlays(bool visible) async {
    //await SystemChrome.setPreferredOrientations(this.orientations);
    if (visible) {
      await SystemChrome.setEnabledSystemUIMode(
          edgeToedge ? SystemUiMode.edgeToEdge : SystemUiMode.immersive,
          overlays: this.overlays);
    } else {
      //print("Closed2");
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []);
    }
    //}
  }

  /// hide the statusBar and the navigation bar, set only landscape mode only if forceLandScapeInFullscreen is true
  Future<void> setFullScreenOverlaysAndOrientations({
    hideOverLays = true,
  }) async {
    this.forceLandScapeInFullscreen
        ? AutoOrientation.landscapeAutoMode(forceSensor: true)
        : AutoOrientation.fullAutoMode();

    if (hideOverLays) {
      setOverlays(false);
    }
    //AutoOrientation.landscapeAutoMode(forceSensor: true);
  }
}
