import 'dart:io';
import 'dart:convert';

class RunCheckService {
  static const supportedSchemaVersions = ['1.0', '1.1'];

  Future<void> checkRunFolder(String runFolderPath) async {
    try {
      await _checkRunFolderAccessible(runFolderPath);

      final manifestFile = await _checkManifestExists(runFolderPath);

      final manifestContent = await _readManifestFile(manifestFile);

      final manifestJson = _parseAndValidateManifest(manifestContent);

      _checkSchemaVersion(manifestJson);

      print('[RunCheckService] Run folder válido');
    } catch (e) {
      print('TODO: SEND UI ERROR: $e');
    }
  }

  Future<void> _checkRunFolderAccessible(String path) async {
    final directory = Directory(path);

    final exists = await directory.exists();
    if (!exists) {
      throw Exception('Run folder does not exist');
    }

    try {
      await directory.list(followLinks: false).first;
    } catch (_) {
      throw Exception('Run folder is not accessible');
    }
  }

  Future<File> _checkManifestExists(String runFolderPath) async {
    final manifestPath = '$runFolderPath/artifact_manifest.json';
    final file = File(manifestPath);

    if (!await file.exists()) {
      throw Exception('artifact_manifest.json not found');
    }

    return file;
  }

  Future<String> _readManifestFile(File manifestFile) async {
    try {
      return await manifestFile.readAsString();
    } catch (_) {
      throw Exception('Failed to read artifact_manifest.json');
    }
  }

  Map<String, dynamic> _parseAndValidateManifest(String content) {
    late final dynamic decoded;

    try {
      decoded = jsonDecode(content);
    } catch (_) {
      throw Exception('artifact_manifest.json is not valid JSON');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('artifact_manifest.json must contain a JSON object');
    }

    if (!decoded.containsKey('schemaVersion')) {
      throw Exception('artifact_manifest.json missing schemaVersion');
    }

    return decoded;
  }

  void _checkSchemaVersion(Map<String, dynamic> manifestJson) {
    final schemaVersion = manifestJson['schemaVersion'];

    if (schemaVersion is! String) {
      throw Exception('schemaVersion must be a string');
    }

    if (!supportedSchemaVersions.contains(schemaVersion)) {
      throw Exception('Unsupported schemaVersion: $schemaVersion');
    }
  }
}
