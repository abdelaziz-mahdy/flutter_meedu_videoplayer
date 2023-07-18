import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_meedu/meedu.dart';

class PipManager {
  final _channel = const MethodChannel("com.zezo357.flutter_meedu_videoplayer");

  final Completer<double> _osVersion = Completer();
  final Completer<bool> _pipAvailable = Completer();

  Rx<bool> isInPipMode = false.obs;

  PipManager() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPictureInPictureModeChanged') {
        isInPipMode.value = call.arguments;
      }
    });
  }

  Future<double> get osVersion async {
    return _osVersion.future;
  }

  Future<bool> get pipAvailable async {
    return _pipAvailable.future;
  }

  Future<void> _getOSVersion() async {
    final os0 = await _channel.invokeMethod<String>('osVersion');
    final os = double.parse(os0!);
    _osVersion.complete(os);
  }

  Future<void> enterPip() async {
    await _channel.invokeMethod('enterPip');
  }

  Future<bool> checkPipAvailable() async {
    bool available = false;
    if (Platform.isAndroid) {
      await _channel.invokeMethod('initPipConfiguration');
      await _getOSVersion();
      final osVersion = await _osVersion.future;
      // check the OS version
      if (osVersion >= 7) {
        return true;
      }
    }
    _pipAvailable.complete(available);
    return available;
  }

  Future<void> dispose() async {
    isInPipMode.close();
  }
}
