/*
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:meedu/rx.dart';

class PipManager {
  final _channel = MethodChannel("app.meedu.player");

  Completer<double> _osVersion = Completer();
  Completer<bool> _pipAvailable = Completer();

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
    final _os = await _channel.invokeMethod<String>('osVersion');
    final os = double.parse(_os!);
    this._osVersion.complete(os);
  }

  Future<void> enterPip() async {
    await _channel.invokeMethod('enterPip');
  }

  Future<bool> checkPipAvailable() async {
    bool available = false;
    if (Platform.isAndroid) {
      await this._channel.invokeMethod('initPipConfiguration');
      await _getOSVersion();
      final osVersion = await _osVersion.future;
      // check the OS version
      if (osVersion >= 7) {
        return true;
      }
    }
    this._pipAvailable.complete(available);
    return available;
  }

  Future<void> dispose() async {
    isInPipMode.close();
  }
}*/
