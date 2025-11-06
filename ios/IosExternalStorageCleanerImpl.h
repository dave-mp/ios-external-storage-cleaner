#ifdef RCT_NEW_ARCH_ENABLED
#import <IosExternalStorageCleaner/IosExternalStorageCleaner.h>

@interface IosExternalStorageCleaner : NativeIosExternalStorageCleanerSpecBase <NativeIosExternalStorageCleanerSpec>
@end

#else
#import <React/RCTBridgeModule.h>

@interface IosExternalStorageCleaner : NSObject <RCTBridgeModule>
@end

#endif
