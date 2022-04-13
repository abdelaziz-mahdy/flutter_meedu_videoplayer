//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dart_vlc/dart_vlc_plugin.h>
#include <flutter_meedu_videoplayer/flutter_meedu_videoplayer_plugin.h>
#include <hotkey_manager/hotkey_manager_plugin.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DartVlcPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DartVlcPlugin"));
  FlutterMeeduVideoplayerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterMeeduVideoplayerPlugin"));
  HotkeyManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HotkeyManagerPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
