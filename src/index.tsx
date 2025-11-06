import IosExternalStorageCleaner from './NativeIosExternalStorageCleaner';
import type {
  FolderPickResult,
  CleanResult,
} from './NativeIosExternalStorageCleaner';

export type { FolderPickResult, CleanResult };

export function multiply(a: number, b: number): number {
  return IosExternalStorageCleaner.multiply(a, b);
}

/**
 * Opens a folder picker to select an external storage device (SD card or USB drive).
 * Returns the folder path and a security-scoped bookmark for future access.
 */
export function pickFolder(): Promise<FolderPickResult> {
  return IosExternalStorageCleaner.pickFolder();
}

/**
 * Cleans system files and hidden files from the external storage using a previously saved bookmark.
 * Removes: .Trashes, .Spotlight-V100, .fseventsd, .DS_Store, and ._* files
 *
 * @param bookmarkBase64 - The base64-encoded bookmark from pickFolder()
 * @returns Promise with number of deleted items, errors, and whether bookmark is stale
 */
export function cleanWithBookmark(
  bookmarkBase64: string
): Promise<CleanResult> {
  return IosExternalStorageCleaner.cleanWithBookmark(bookmarkBase64);
}
