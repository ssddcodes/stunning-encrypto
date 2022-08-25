#include "include/encrypto_flutter/encrypto_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "encrypto_flutter_plugin.h"

void EncryptoFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  encrypto_flutter::EncryptoFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
