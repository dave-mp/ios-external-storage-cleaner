# react-native-ios-external-storage-cleaner

Delete all files and folders from external storage devices (SD cards, USB drives) on iOS.

⚠️ **Warning:** This library will delete **ALL** files and folders in the selected directory, including hidden files. Use with caution!

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
    console.log('Selected folder:', result.folderName);
    console.log('Full path:', result.folderPath);
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

// Step 2: Delete all files using the bookmark
async function cleanExternalStorage(bookmarkBase64: string) {
  try {
    const result: CleanResult = await cleanWithBookmark(bookmarkBase64);
    console.log(`Deleted ${result.deletedFiles.length} items`);
    
    // Show what was deleted
    if (result.deletedFiles.length > 0) {
      console.log('Deleted files:');
      result.deletedFiles.forEach(file => {
        console.log(`- ${file}`);
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
  folderPath: string;      // Full path to the selected folder
  folderName: string;      // Name of the selected folder (e.g., "MyDrive")
  bookmarkBase64: string;  // Security-scoped bookmark for future access
};
```

**Throws:**
- `NO_ROOT_VC`: Cannot find root view controller
- `IOS_VERSION`: iOS version is below 14.0
- `CANCELLED`: User cancelled the folder selection
- `ACCESS_ERROR`: Failed to access security-scoped resource

### `cleanWithBookmark(bookmarkBase64: string)`

⚠️ **Deletes ALL files and folders from the previously selected directory.**

**Parameters:**
- `bookmarkBase64` - The base64-encoded bookmark from `pickFolder()`

**Returns:** `Promise<CleanResult>`

```typescript
type CleanResult = {
  deletedFiles: Array<string>;  // Array of file/folder names that were deleted
  stale: boolean;               // Whether the bookmark is stale
};
```

**Behavior:**
- Deletes **everything** in the selected folder (files and subdirectories)
- Includes all hidden files (files starting with `.`)
- Only returns successfully deleted items
- Items that fail to delete are silently skipped

**Throws:**
- `NO_URL`: No folder has been selected yet
- `READ_ERROR`: Failed to read directory contents


## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
