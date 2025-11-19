import { TurboModuleRegistry, type TurboModule } from 'react-native';

export type FolderPickResult = {
  folderPath: string;
  folderName: string;
  bookmarkBase64: string;
};

export type CleanResult = {
  deletedFiles: Array<string>;
  stale: boolean;
};

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  pickFolder(): Promise<FolderPickResult>;
  cleanWithBookmark(bookmarkBase64: string): Promise<CleanResult>;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'IosExternalStorageCleaner'
);
