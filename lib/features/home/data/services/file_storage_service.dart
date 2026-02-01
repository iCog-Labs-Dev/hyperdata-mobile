import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/utils/storage_logger.dart';
import '../../../../core/utils/storage_error_handler.dart';

/// Service for managing file system operations for audio recordings
class FileStorageService {
  static const String _recordingsFolderName = 'recordings';

  /// Get the recordings directory path
  Future<String> getRecordingsDirectory() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final recordingsPath = '${appDocDir.path}/$_recordingsFolderName';
      final recordingsDir = Directory(recordingsPath);

      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
        StorageLogger.logRecordingsDirectoryCreated(recordingsPath);
      }

      return recordingsPath;
    } catch (e) {
      StorageLogger.logRecordingsDirectoryError(e);
      StorageErrorHandler.handleDirectoryCreationError(e, showToUser: false);
      rethrow;
    }
  }

  /// Get task-specific directory
  Future<Directory> getTaskDirectory(String taskId) async {
    try {
      final recordingsPath = await getRecordingsDirectory();
      final taskDirPath = '$recordingsPath/$taskId';
      final taskDir = Directory(taskDirPath);

      if (!await taskDir.exists()) {
        await taskDir.create(recursive: true);
        StorageLogger.logTaskDirectoryCreated(taskId, taskDirPath);
      }

      return taskDir;
    } catch (e) {
      StorageLogger.logTaskDirectoryError(taskId, e);
      StorageErrorHandler.handleDirectoryCreationError(e, showToUser: false);
      rethrow;
    }
  }

  /// Save audio file to proper location
  /// Returns the path to the saved file
  Future<String> saveAudioFile(
    String taskId,
    String microTaskId,
    File sourceFile,
  ) async {
    try {
      final taskDir = await getTaskDirectory(taskId);
      final fileName = '$microTaskId.aac';
      final targetPath = '${taskDir.path}/$fileName';

      // Check if source and target are the same
      if (sourceFile.path == targetPath) {
        // File is already in the correct location, no need to copy
        StorageLogger.logAudioFileSaved(taskId, microTaskId, targetPath);
        return targetPath;
      }

      // Copy the source file to the target location
      await sourceFile.copy(targetPath);
      StorageLogger.logAudioFileSaved(taskId, microTaskId, targetPath);

      return targetPath;
    } catch (e) {
      StorageLogger.logAudioFileSaveError(taskId, microTaskId, e);
      StorageErrorHandler.handleAudioSaveError(e, showToUser: false);
      rethrow;
    }
  }

  /// Delete audio file
  Future<void> deleteAudioFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        StorageLogger.logAudioFileDeleted(filePath);
      }
    } catch (e) {
      StorageLogger.logAudioFileDeleteError(filePath, e);
      StorageErrorHandler.handleDeleteError(e, showToUser: false);
      rethrow;
    }
  }

  /// Delete all files for a task
  Future<void> deleteTaskFiles(String taskId) async {
    try {
      final recordingsPath = await getRecordingsDirectory();
      final taskDirPath = '$recordingsPath/$taskId';
      final taskDir = Directory(taskDirPath);

      if (await taskDir.exists()) {
        await taskDir.delete(recursive: true);
        StorageLogger.logTaskFilesDeleted(taskId);
      }
    } catch (e) {
      StorageLogger.logTaskFilesDeleteError(taskId, e);
      StorageErrorHandler.handleDeleteError(e, showToUser: false);
      rethrow;
    }
  }

  /// Verify file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      final exists = await file.exists();
      StorageLogger.logFileExistenceCheck(filePath, exists);
      return exists;
    } catch (e) {
      StorageLogger.logFileExistenceCheckError(filePath, e);
      return false;
    }
  }

  /// Clean up orphaned files
  /// Removes files and directories for tasks not in the validTaskIds list
  Future<void> cleanupOrphanedFiles(List<String> validTaskIds) async {
    try {
      final recordingsPath = await getRecordingsDirectory();
      final recordingsDir = Directory(recordingsPath);

      if (!await recordingsDir.exists()) {
        return;
      }

      StorageLogger.logOrphanedCleanupStarted(validTaskIds.length);

      // List all task directories
      final taskDirs = await recordingsDir.list().toList();

      for (final entity in taskDirs) {
        if (entity is Directory) {
          final taskId = entity.path.split(Platform.pathSeparator).last;

          // If this task ID is not in the valid list, delete it
          if (!validTaskIds.contains(taskId)) {
            await entity.delete(recursive: true);
            StorageLogger.logOrphanedDirectoryRemoved(taskId);
          } else {
            // Check if the directory is empty and remove it
            await _removeEmptyDirectory(entity);
          }
        }
      }
    } catch (e) {
      StorageLogger.logOrphanedCleanupError(e);
      StorageErrorHandler.handleCleanupError(e, showToUser: false);
      rethrow;
    }
  }

  /// Remove empty task directories
  Future<void> _removeEmptyDirectory(Directory directory) async {
    try {
      final contents = await directory.list().toList();
      if (contents.isEmpty) {
        await directory.delete();
        StorageLogger.logEmptyDirectoryRemoved(directory.path);
      }
    } catch (e) {
      StorageLogger.logAudioFileDeleteError(directory.path, e);
      // Don't rethrow, this is a cleanup operation
    }
  }
}
