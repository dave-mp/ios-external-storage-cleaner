import { useState } from 'react';
import {
  Text,
  View,
  StyleSheet,
  Button,
  ScrollView,
  Alert,
} from 'react-native';
import {
  pickFolder,
  cleanWithBookmark,
  type FolderPickResult,
  type CleanResult,
} from 'react-native-ios-external-storage-cleaner';

export default function App() {
  const [folderInfo, setFolderInfo] = useState<FolderPickResult | null>(null);
  const [cleanResult, setCleanResult] = useState<CleanResult | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handlePickFolder = async () => {
    try {
      setIsLoading(true);
      const result = await pickFolder();
      setFolderInfo(result);
      setCleanResult(null);
      Alert.alert('Success', `Selected: ${result.folderPath}`);
    } catch (error: any) {
      if (error.code !== 'CANCELLED') {
        Alert.alert('Error', error.message || 'Failed to pick folder');
      }
    } finally {
      setIsLoading(false);
    }
  };

  const handleClean = async () => {
    if (!folderInfo) {
      Alert.alert('Error', 'Please select a folder first');
      return;
    }

    try {
      setIsLoading(true);
      const result = await cleanWithBookmark(folderInfo.bookmarkBase64);
      setCleanResult(result);

      const message = `Deleted ${result.deletedFiles.length} items${
        result.stale ? '\n⚠️ Bookmark is stale' : ''
      }`;

      Alert.alert('Cleaning Complete', message);
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to clean folder');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Text style={styles.title}>iOS External Storage Cleaner</Text>
      <Text style={styles.subtitle}>
        Delete ALL files from SD cards and USB drives
      </Text>

      <View style={styles.buttonContainer}>
        <Button
          title="📁 Select External Storage"
          onPress={handlePickFolder}
          disabled={isLoading}
        />
      </View>

      {folderInfo && (
        <View style={styles.infoBox}>
          <Text style={styles.infoTitle}>Selected Folder:</Text>
          <Text style={styles.infoText}>{folderInfo.folderPath}</Text>

          <View style={styles.buttonContainer}>
            <Button
              title="🧹 Clean Files"
              onPress={handleClean}
              disabled={isLoading}
              color="#FF6B6B"
            />
          </View>
        </View>
      )}

      {cleanResult && (
        <View style={styles.resultBox}>
          <Text style={styles.resultTitle}>Cleaning Results:</Text>
          <Text style={styles.resultText}>
            ✅ Deleted: {cleanResult.deletedFiles.length} items
          </Text>
          {cleanResult.stale && (
            <Text style={styles.warningText}>⚠️ Bookmark is stale</Text>
          )}

          {cleanResult.deletedFiles.length > 0 && (
            <ScrollView style={styles.filesContainer}>
              <Text style={styles.filesTitle}>Deleted Files:</Text>
              {cleanResult.deletedFiles.slice(0, 20).map((file, idx) => (
                <Text key={idx} style={styles.fileText}>
                  • {file}
                </Text>
              ))}
              {cleanResult.deletedFiles.length > 20 && (
                <Text style={styles.fileText}>
                  ... and {cleanResult.deletedFiles.length - 20} more
                </Text>
              )}
            </ScrollView>
          )}
        </View>
      )}

      <View style={styles.infoBox}>
        <Text style={styles.helpTitle}>⚠️ Warning:</Text>
        <Text style={styles.helpText}>
          This will delete ALL files and folders in the selected directory,
          including hidden files. This action cannot be undone!
        </Text>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  content: {
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginTop: 40,
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 14,
    textAlign: 'center',
    color: '#666',
    marginBottom: 30,
  },
  buttonContainer: {
    marginVertical: 10,
  },
  infoBox: {
    backgroundColor: 'white',
    padding: 15,
    borderRadius: 10,
    marginVertical: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  infoTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 5,
  },
  infoText: {
    fontSize: 14,
    color: '#333',
    marginBottom: 10,
  },
  resultBox: {
    backgroundColor: '#E8F5E9',
    padding: 15,
    borderRadius: 10,
    marginVertical: 10,
  },
  resultTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#2E7D32',
  },
  resultText: {
    fontSize: 14,
    marginVertical: 3,
    color: '#333',
  },
  warningText: {
    fontSize: 14,
    marginVertical: 3,
    color: '#FF9800',
    fontWeight: '600',
  },
  filesContainer: {
    marginTop: 10,
    paddingTop: 10,
    borderTopWidth: 1,
    borderTopColor: '#DDD',
    maxHeight: 200,
  },
  filesTitle: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 5,
    color: '#2E7D32',
  },
  fileText: {
    fontSize: 12,
    color: '#666',
    marginVertical: 2,
  },
  helpTitle: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 8,
  },
  helpText: {
    fontSize: 13,
    color: '#666',
    marginVertical: 2,
  },
});
