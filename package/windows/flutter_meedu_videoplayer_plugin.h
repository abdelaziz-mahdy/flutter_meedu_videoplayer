#ifndef FLUTTER_PLUGIN_FLUTTER_MEEDU_VIDEOPLAYER_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_MEEDU_VIDEOPLAYER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_meedu_videoplayer {

class FlutterMeeduVideoplayerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterMeeduVideoplayerPlugin();

  virtual ~FlutterMeeduVideoplayerPlugin();

  // Disallow copy and assign.
  FlutterMeeduVideoplayerPlugin(const FlutterMeeduVideoplayerPlugin&) = delete;
  FlutterMeeduVideoplayerPlugin& operator=(const FlutterMeeduVideoplayerPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_meedu_videoplayer

#endif  // FLUTTER_PLUGIN_FLUTTER_MEEDU_VIDEOPLAYER_PLUGIN_H_
