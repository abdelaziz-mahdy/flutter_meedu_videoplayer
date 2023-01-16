import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_meedu_videoplayer/flutter_meedu_videoplayer_method_channel.dart';

void main() {
  MethodChannelFlutterMeeduVideoplayer platform = MethodChannelFlutterMeeduVideoplayer();
  const MethodChannel channel = MethodChannel('flutter_meedu_videoplayer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
