import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'encrypto_flutter_platform_interface.dart';

/// An implementation of [EncryptoFlutterPlatform] that uses method channels.
class MethodChannelEncryptoFlutter extends EncryptoFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('encrypto_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
