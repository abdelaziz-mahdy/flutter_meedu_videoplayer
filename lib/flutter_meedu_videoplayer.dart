
import 'flutter_meedu_videoplayer_platform_interface.dart';

class FlutterMeeduVideoplayer {
  Future<String?> getPlatformVersion() {
    return FlutterMeeduVideoplayerPlatform.instance.getPlatformVersion();
  }
}
