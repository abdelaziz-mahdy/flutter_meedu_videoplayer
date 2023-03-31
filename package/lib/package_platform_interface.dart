import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package_method_channel.dart';

abstract class PackagePlatform extends PlatformInterface {
  /// Constructs a PackagePlatform.
  PackagePlatform() : super(token: _token);

  static final Object _token = Object();

  static PackagePlatform _instance = MethodChannelPackage();

  /// The default instance of [PackagePlatform] to use.
  ///
  /// Defaults to [MethodChannelPackage].
  static PackagePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PackagePlatform] when
  /// they register themselves.
  static set instance(PackagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
