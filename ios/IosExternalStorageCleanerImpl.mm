#import "IosExternalStorageCleanerImpl.h"

@implementation IosExternalStorageCleaner

RCT_EXPORT_MODULE(IosExternalStorageCleaner)

#ifdef RCT_NEW_ARCH_ENABLED
// TurboModule implementation for new architecture
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
    return result;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeIosExternalStorageCleanerSpecJSI>(params);
}
#else
// Old architecture - export synchronous method
RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, multiply:(double)a b:(double)b)
{
    NSNumber *result = @(a * b);
    return result;
}
#endif

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

@end



