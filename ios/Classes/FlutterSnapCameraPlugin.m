#import "FlutterSnapCameraPlugin.h"
#if __has_include(<flutter_snap_camera/flutter_snap_camera-Swift.h>)
#import <flutter_snap_camera/flutter_snap_camera-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_snap_camera-Swift.h"
#endif

@implementation FlutterSnapCameraPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSnapCameraPlugin registerWithRegistrar:registrar];
}
@end
