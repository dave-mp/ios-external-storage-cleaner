# react-native-ios-external-storage-cleaner

Clean system files and hidden files from external storage devices (SD cards, USB drives) on iOS.

This library removes macOS-specific system files that can clutter external storage when used with iOS devices:
- `.DS_Store` files
- `.Trashes` folders
- `.Spotlight-V100` indexes
- `.fseventsd` folders
- `._*` AppleDouble files

## Installation

```sh
npm install react-native-ios-external-storage-cleaner
```

## Requirements

- iOS 14.0 or later (for `UIDocumentPickerViewController` folder support)
- React Native 0.60 or later

## Usage

```js
import { 
  pickFolder, 
  cleanWithBookmark,
  type FolderPickResult,
  type CleanResult 
} from 'react-native-ios-external-storage-cleaner';

// Step 1: Let the user pick an external storage folder
async function selectExternalStorage() {
  try {
    const result: FolderPickResult = await pickFolder();
    console.log('Selected folder:', result.folderPath);
    console.log('Bookmark:', result.bookmarkBase64);
    
    // Save the bookmark for later use
    return result.bookmarkBase64;
  } catch (error) {
    if (error.code === 'CANCELLED') {
      console.log('User cancelled folder selection');
    } else {
      console.error('Error picking folder:', error);
    }
  }
}

// Step 2: Clean the files using the bookmark
async function cleanExternalStorage(bookmarkBase64: string) {
  try {
    const result: CleanResult = await cleanWithBookmark(bookmarkBase64);
    console.log(`Deleted ${result.deleted} items`);
    
    if (result.errors.length > 0) {
      console.log('Errors encountered:');
      result.errors.forEach(err => {
        console.log(`- ${err.path}: ${err.error}`);
      });
    }
    
    if (result.stale) {
      console.log('Bookmark is stale, please select the folder again');
    }
  } catch (error) {
    console.error('Error cleaning storage:', error);
  }
}

// Complete workflow
async function cleanMyExternalDrive() {
  const bookmark = await selectExternalStorage();
  if (bookmark) {
    await cleanExternalStorage(bookmark);
  }
}
```

## API

### `pickFolder()`

Opens a folder picker to let the user select an external storage device.

**Returns:** `Promise<FolderPickResult>`

```typescript
type FolderPickResult = {
  folderPath: string;      // Path to the selected folder
  bookmarkBase64: string;  // Security-scoped bookmark for future access
};
```

**Throws:**
- `NO_ROOT_VC`: Cannot find root view controller
- `IOS_VERSION`: iOS version is below 14.0
- `CANCELLED`: User cancelled the folder selection
- `ACCESS_ERROR`: Failed to access security-scoped resource

### `cleanWithBookmark(bookmarkBase64: string)`

Cleans system files and hidden files from the previously selected folder.

**Parameters:**
- `bookmarkBase64` - The base64-encoded bookmark from `pickFolder()`

**Returns:** `Promise<CleanResult>`

```typescript
type CleanResult = {
  deleted: number;                              // Number of items successfully deleted
  errors: Array<{ path: string; error: string }>; // Any errors encountered
  stale: boolean;                               // Whether the bookmark is stale
};
```

**Files removed:**
- `.Trashes`, `.trashes`, `.Trash`, `.Trash-1000`
- `.Spotlight-V100`
- `.fseventsd`
- `.DS_Store`
- All files starting with `._` (AppleDouble files)

**Throws:**
- `NO_URL`: No folder has been selected yet


## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
