import 'dart:io';
import 'package:dart_vlc/dart_vlc.dart';

Future<void> initDartVlc() async {
  if (Platform.isWindows || Platform.isLinux) {
    DartVLC.initialize();
  }
  if (Platform.isMacOS) {
    throw UnsupportedError('MacOs is not supported');
  }
}
