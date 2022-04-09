import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_meedu_videoplayer/flutter_meedu_videoplayer.dart';

void main() {
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
    expect(await FlutterMeeduVideoplayer.platformVersion, '42');
  });
}
