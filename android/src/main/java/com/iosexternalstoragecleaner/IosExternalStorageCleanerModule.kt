package com.iosexternalstoragecleaner

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Promise
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = IosExternalStorageCleanerModule.NAME)
class IosExternalStorageCleanerModule(reactContext: ReactApplicationContext) :
  NativeIosExternalStorageCleanerSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  override fun pickFolder(promise: Promise) {
    promise.reject("UNSUPPORTED", "This feature is only available on iOS")
  }

  override fun cleanWithBookmark(bookmarkBase64: String, promise: Promise) {
    promise.reject("UNSUPPORTED", "This feature is only available on iOS")
  }

  companion object {
    const val NAME = "IosExternalStorageCleaner"
  }
}
