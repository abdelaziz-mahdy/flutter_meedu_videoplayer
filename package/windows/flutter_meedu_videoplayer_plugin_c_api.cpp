#include "include/flutter_meedu_videoplayer/flutter_meedu_videoplayer_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_meedu_videoplayer_plugin.h"

void FlutterMeeduVideoplayerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_meedu_videoplayer::FlutterMeeduVideoplayerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
