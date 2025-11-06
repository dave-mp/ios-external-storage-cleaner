#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import <IosExternalStorageCleaner/IosExternalStorageCleaner.h>
#import <ReactCommon/RCTTurboModule.h>

@interface IosExternalStorageCleaner : NativeIosExternalStorageCleanerSpecBase <NativeIosExternalStorageCleanerSpec, RCTTurboModule, UIDocumentPickerDelegate>
#else
@interface IosExternalStorageCleaner : NSObject <RCTBridgeModule, UIDocumentPickerDelegate>
#endif

@property (nonatomic, copy) RCTPromiseResolveBlock pickerResolver;
@property (nonatomic, copy) RCTPromiseRejectBlock pickerRejecter;
@property (nonatomic, strong) NSURL *securedURL;

@end
