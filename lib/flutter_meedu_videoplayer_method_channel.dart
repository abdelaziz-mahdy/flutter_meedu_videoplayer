import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_meedu_videoplayer_platform_interface.dart';

/// An implementation of [FlutterMeeduVideoplayerPlatform] that uses method channels.
class MethodChannelFlutterMeeduVideoplayer extends FlutterMeeduVideoplayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_meedu_videoplayer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
