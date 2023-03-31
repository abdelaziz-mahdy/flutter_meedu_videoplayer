#include "include/package/package_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "package_plugin.h"

void PackagePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  package::PackagePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
