import 'dart:io';

Future<void> initDartVlc() async {
  if (Platform.isMacOS) {
    throw UnsupportedError('MacOs is not supported');
  }
}
