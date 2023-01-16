import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_meedu_videoplayer_method_channel.dart';

abstract class FlutterMeeduVideoplayerPlatform extends PlatformInterface {
  /// Constructs a FlutterMeeduVideoplayerPlatform.
  FlutterMeeduVideoplayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMeeduVideoplayerPlatform _instance = MethodChannelFlutterMeeduVideoplayer();

  /// The default instance of [FlutterMeeduVideoplayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMeeduVideoplayer].
  static FlutterMeeduVideoplayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMeeduVideoplayerPlatform] when
  /// they register themselves.
  static set instance(FlutterMeeduVideoplayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
