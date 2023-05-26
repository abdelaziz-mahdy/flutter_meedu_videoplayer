#include "include/flutter_meedu_media_kit/flutter_meedu_media_kit_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_meedu_media_kit_plugin.h"

void FlutterMeeduVideoplayerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_meedu_media_kit::FlutterMeeduVideoplayerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
