#import "IosExternalStorageCleanerImpl.h"

@implementation IosExternalStorageCleaner

RCT_EXPORT_MODULE(IosExternalStorageCleaner)

// Synchronous method implementation for both architectures
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
    return result;
}

#ifndef RCT_NEW_ARCH_ENABLED
// For old architecture, export the method as synchronous
RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, multiply:(double)a b:(double)b)
{
    return [self multiply:a b:b];
}
#else
// For new architecture, provide getTurboModule
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeIosExternalStorageCleanerSpecJSI>(params);
}
#endif

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

@end



