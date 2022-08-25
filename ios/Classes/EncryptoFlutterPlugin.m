#import "EncryptoFlutterPlugin.h"
#if __has_include(<encrypto_flutter/encrypto_flutter-Swift.h>)
#import <encrypto_flutter/encrypto_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "encrypto_flutter-Swift.h"
#endif

@implementation EncryptoFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEncryptoFlutterPlugin registerWithRegistrar:registrar];
}
@end
