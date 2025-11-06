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
 * Deletes ALL files and folders from the selected external storage.
 * WARNING: This will delete everything in the selected folder, including all hidden files.
 *
 * @param bookmarkBase64 - The base64-encoded bookmark from pickFolder()
 * @returns Promise with array of deleted file names and whether bookmark is stale
 */
export function cleanWithBookmark(
  bookmarkBase64: string
): Promise<CleanResult> {
  return IosExternalStorageCleaner.cleanWithBookmark(bookmarkBase64);
}
