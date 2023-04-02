import 'package:flutter_test/flutter_test.dart';
import 'package:package/package.dart';
import 'package:package/package_platform_interface.dart';
import 'package:package/package_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPackagePlatform
    with MockPlatformInterfaceMixin
    implements PackagePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PackagePlatform initialPlatform = PackagePlatform.instance;

  test('$MethodChannelPackage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPackage>());
  });

  test('getPlatformVersion', () async {
    Package packagePlugin = Package();
    MockPackagePlatform fakePlatform = MockPackagePlatform();
    PackagePlatform.instance = fakePlatform;

    expect(await packagePlugin.getPlatformVersion(), '42');
  });
}
