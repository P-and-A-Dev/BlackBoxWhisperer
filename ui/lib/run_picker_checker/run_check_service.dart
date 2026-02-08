import 'dart:convert';
import 'dart:io';

import 'package:blackbox_ui/models/artifact_manifest.dart';
import 'package:blackbox_ui/models/run_load_result.dart';

class RunCheckService {
  static const supportedSchemaVersions = ['1.0', '1.1'];

  Future<RunLoadResult> loadRunFolder(String runFolderPath) async {
    try {
      await _checkRunFolderAccessible(runFolderPath);

      final manifestFile = await _checkManifestExists(runFolderPath);

      final manifestContent = await _readManifestFile(manifestFile);

      final manifestJson = _parseAndValidateManifest(manifestContent);

      _checkSchemaVersion(manifestJson);

      final manifest = ArtifactManifest.fromJson(manifestJson);

      return RunLoadSuccess(runFolderPath, manifest);
    } on RunLoadError catch (e) {
      return e;
    } catch (e) {
      return RunLoadError(
        'Unexpected error: $e',
        RunLoadErrorType.manifestInvalidStructure,
      );
    }
  }

  Future<void> _checkRunFolderAccessible(String path) async {
    final directory = Directory(path);

    final exists = await directory.exists();
    if (!exists) {
      throw RunLoadError(
        'Run folder does not exist',
        RunLoadErrorType.folderNotFound,
      );
    }

    try {
      await directory.list(followLinks: false).first;
    } catch (_) {
      throw RunLoadError(
        'Run folder is not accessible',
        RunLoadErrorType.folderNotAccessible,
      );
    }
  }

  Future<File> _checkManifestExists(String runFolderPath) async {
    final manifestPath = '$runFolderPath/artifact_manifest.json';
    final file = File(manifestPath);

    if (!await file.exists()) {
      throw RunLoadError(
        'artifact_manifest.json not found in run folder',
        RunLoadErrorType.manifestNotFound,
      );
    }

    return file;
  }

  Future<String> _readManifestFile(File manifestFile) async {
    try {
      return await manifestFile.readAsString();
    } catch (_) {
      throw RunLoadError(
        'Failed to read artifact_manifest.json',
        RunLoadErrorType.manifestNotReadable,
      );
    }
  }

  Map<String, dynamic> _parseAndValidateManifest(String content) {
    late final dynamic decoded;

    try {
      decoded = jsonDecode(content);
    } catch (e) {
      throw RunLoadError(
        'artifact_manifest.json is not valid JSON: $e',
        RunLoadErrorType.manifestInvalidJson,
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw RunLoadError(
        'artifact_manifest.json must contain a JSON object',
        RunLoadErrorType.manifestInvalidStructure,
      );
    }

    if (!decoded.containsKey('schemaVersion')) {
      throw RunLoadError(
        'artifact_manifest.json is missing required field: schemaVersion',
        RunLoadErrorType.manifestMissingSchemaVersion,
      );
    }

    return decoded;
  }

  void _checkSchemaVersion(Map<String, dynamic> manifestJson) {
    final schemaVersion = manifestJson['schemaVersion'];

    if (schemaVersion is! String) {
      throw RunLoadError(
        'schemaVersion must be a string',
        RunLoadErrorType.manifestInvalidStructure,
      );
    }

    if (!supportedSchemaVersions.contains(schemaVersion)) {
      throw RunLoadError(
        'Unsupported schemaVersion: $schemaVersion. Supported versions: ${supportedSchemaVersions.join(", ")}',
        RunLoadErrorType.manifestUnsupportedVersion,
      );
    }
  }
}
