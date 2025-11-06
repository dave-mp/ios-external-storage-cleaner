#import "IosExternalStorageCleanerImpl.h"

@implementation IosExternalStorageCleaner

RCT_EXPORT_MODULE(IosExternalStorageCleaner)

// Synchronous method - works for both old and new architecture
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
    return result;
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeIosExternalStorageCleanerSpecJSI>(params);
}
#endif

// Tell React Native this is a turbo module
+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

@end



