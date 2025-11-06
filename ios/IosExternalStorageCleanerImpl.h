#import <React/RCTBridgeModule.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import <IosExternalStorageCleaner/IosExternalStorageCleaner.h>
#import <ReactCommon/RCTTurboModule.h>

@interface IosExternalStorageCleaner : NativeIosExternalStorageCleanerSpecBase <NativeIosExternalStorageCleanerSpec, RCTTurboModule>
#else
@interface IosExternalStorageCleaner : NSObject <RCTBridgeModule>
#endif

@end
