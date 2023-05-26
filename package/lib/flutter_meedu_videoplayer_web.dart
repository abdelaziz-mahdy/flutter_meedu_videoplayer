// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the FlutterMeeduMediaKitPlatform of the FlutterMeeduMediaKit plugin.
class FlutterMeeduMediaKitWeb {
  /// Constructs a FlutterMeeduMediaKitWeb
  FlutterMeeduMediaKitWeb();

  static void registerWith(Registrar registrar) {}
}
