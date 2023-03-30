#import "FlutterMeeduVideoplayerPlugin.h"
#if __has_include(<flutter_meedu_videoplayer/flutter_meedu_videoplayer-Swift.h>)
#import <flutter_meedu_videoplayer/flutter_meedu_videoplayer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_meedu_videoplayer-Swift.h"
#endif

@implementation FlutterMeeduVideoplayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMeeduVideoplayerPlugin registerWithRegistrar:registrar];
}
@end
