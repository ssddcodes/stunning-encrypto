import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'encrypto_flutter_method_channel.dart';

abstract class EncryptoFlutterPlatform extends PlatformInterface {
  /// Constructs a EncryptoFlutterPlatform.
  EncryptoFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static EncryptoFlutterPlatform _instance = MethodChannelEncryptoFlutter();

  /// The default instance of [EncryptoFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelEncryptoFlutter].
  static EncryptoFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EncryptoFlutterPlatform] when
  /// they register themselves.
  static set instance(EncryptoFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
