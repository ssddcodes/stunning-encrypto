import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:encrypto_flutter/encrypto_flutter_method_channel.dart';

void main() {
  MethodChannelEncryptoFlutter platform = MethodChannelEncryptoFlutter();
  const MethodChannel channel = MethodChannel('encrypto_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
