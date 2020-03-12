#import "FeatureDetectPlugin.h"
#if __has_include(<feature_detect/feature_detect-Swift.h>)
#import <feature_detect/feature_detect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "feature_detect-Swift.h"
#endif

@implementation FeatureDetectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFeatureDetectPlugin registerWithRegistrar:registrar];
}
@end
