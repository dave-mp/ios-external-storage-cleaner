#import "IosExternalStorageCleanerImpl.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@implementation IosExternalStorageCleaner

RCT_EXPORT_MODULE(IosExternalStorageCleaner)

#pragma mark - Example Method

#ifdef RCT_NEW_ARCH_ENABLED
// TurboModule implementation for new architecture
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
    return result;
}
#else
// Old architecture - export synchronous method
RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, multiply:(double)a b:(double)b)
{
    NSNumber *result = @(a * b);
    return result;
}
#endif

#pragma mark - Folder Picker

- (void)pickFolder:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pickerResolver = resolve;
        self.pickerRejecter = reject;
        
        if (@available(iOS 14.0, *)) {
            UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] 
                initForOpeningContentTypes:@[UTTypeFolder]];
            picker.delegate = self;
            picker.allowsMultipleSelection = NO;
            
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (rootVC) {
                [rootVC presentViewController:picker animated:YES completion:nil];
            } else {
                reject(@"NO_ROOT_VC", @"Cannot find root view controller", nil);
            }
        } else {
            reject(@"IOS_VERSION", @"This feature requires iOS 14.0 or later", nil);
        }
    });
}

#ifndef RCT_NEW_ARCH_ENABLED
// Export for old architecture
RCT_EXPORT_METHOD(pickFolder:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [self pickFolder:resolve reject:reject];
}
#endif

- (void)documentPicker:(UIDocumentPickerViewController *)controller 
didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls
{
    NSURL *url = urls.firstObject;
    if (!url) {
        if (self.pickerRejecter) {
            self.pickerRejecter(@"NO_URL", @"No folder was selected", nil);
        }
        return;
    }
    
    // Start accessing the security-scoped resource
    BOOL didStart = [url startAccessingSecurityScopedResource];
    if (!didStart) {
        if (self.pickerRejecter) {
            self.pickerRejecter(@"ACCESS_ERROR", @"Failed to access security-scoped resource", nil);
        }
        return;
    }
    
    // Store the URL for later use
    self.securedURL = url;
    
    // Return the path and URL as base64 (for identification purposes)
    NSString *urlString = url.absoluteString;
    NSData *urlData = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [urlData base64EncodedStringWithOptions:0];
    
    if (self.pickerResolver) {
        self.pickerResolver(@{
            @"folderPath": url.path,
            @"bookmarkBase64": base64
        });
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    if (self.pickerRejecter) {
        self.pickerRejecter(@"CANCELLED", @"User cancelled folder selection", nil);
    }
}

#pragma mark - Clean with Bookmark

- (void)cleanWithBookmark:(NSString *)bookmarkBase64
                  resolve:(RCTPromiseResolveBlock)resolve
                   reject:(RCTPromiseRejectBlock)reject
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Use the stored secured URL
        NSURL *rootURL = self.securedURL;
        if (!rootURL) {
            reject(@"NO_URL", @"No folder has been selected yet. Please call pickFolder first.", nil);
            return;
        }
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSMutableArray<NSString *> *deletedFiles = [NSMutableArray array];
        
        // Get all contents of the directory (including hidden files)
        NSError *contentsError = nil;
        NSArray<NSURL *> *contents = [fm contentsOfDirectoryAtURL:rootURL
                                       includingPropertiesForKeys:nil
                                                          options:0
                                                            error:&contentsError];
        
        if (contentsError) {
            reject(@"READ_ERROR", @"Failed to read directory contents", contentsError);
            return;
        }
        
        // Delete each item in the directory
        for (NSURL *itemURL in contents) {
            NSError *deleteError = nil;
            NSString *relativePath = [itemURL lastPathComponent];
            
            if ([fm removeItemAtURL:itemURL error:&deleteError]) {
                [deletedFiles addObject:relativePath];
            }
            // Silently skip items that couldn't be deleted
        }
        
        resolve(@{
            @"deletedFiles": deletedFiles,
            @"stale": @(NO)  // Not using bookmarks, so never stale
        });
    });
}

#ifndef RCT_NEW_ARCH_ENABLED
// Export for old architecture
RCT_EXPORT_METHOD(cleanWithBookmark:(NSString *)bookmarkBase64
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [self cleanWithBookmark:bookmarkBase64 resolve:resolve reject:reject];
}
#endif

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeIosExternalStorageCleanerSpecJSI>(params);
}
#endif

+ (BOOL)requiresMainQueueSetup
{
    return YES; // Changed to YES since we need UI operations
}

@end



