import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package_platform_interface.dart';

/// An implementation of [PackagePlatform] that uses method channels.
class MethodChannelPackage extends PackagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('package');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
