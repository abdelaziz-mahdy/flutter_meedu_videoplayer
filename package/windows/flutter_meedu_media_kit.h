#ifndef FLUTTER_PLUGIN_flutter_meedu_media_kit_PLUGIN_H_
#define FLUTTER_PLUGIN_flutter_meedu_media_kit_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_meedu_media_kit {

class FlutterMeeduMediaKitPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterMeeduMediaKitPlugin();

  virtual ~FlutterMeeduMediaKitPlugin();

  // Disallow copy and assign.
  FlutterMeeduMediaKitPlugin(const FlutterMeeduMediaKitPlugin&) = delete;
  FlutterMeeduMediaKitPlugin& operator=(const FlutterMeeduMediaKitPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_meedu_media_kit

#endif  // FLUTTER_PLUGIN_flutter_meedu_media_kit_PLUGIN_H_
