#ifndef FLUTTER_PLUGIN_PACKAGE_PLUGIN_H_
#define FLUTTER_PLUGIN_PACKAGE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace package {

class PackagePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PackagePlugin();

  virtual ~PackagePlugin();

  // Disallow copy and assign.
  PackagePlugin(const PackagePlugin&) = delete;
  PackagePlugin& operator=(const PackagePlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace package

#endif  // FLUTTER_PLUGIN_PACKAGE_PLUGIN_H_
