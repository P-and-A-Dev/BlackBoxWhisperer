import 'dart:io';
import 'dart:convert';

class RunCheckService {
  static const supportedSchemaVersions = ['1.0', '1.1'];

  /// Ponto de entrada único.
  /// Valida uma pasta de run.
  Future<void> checkRunFolder(String runFolderPath) async {
    try {
      // check if the folder exists and is acessable in the private funncition _checkRunFolderAccessible
      await _checkRunFolderAccessible(runFolderPath);

      // TODO 1.3.2
      // check the presence of artifact_manissfest.json
      final manifestFile = await _checkManifestExists(runFolderPath);

      // TODO 1.3.3
      // read the manisfest file asynchronous
      final manifestContent = await _readManifestFile(manifestFile);

      // TODO 1.3.4
      //Parse the JSON and validate the minimal structure.
      final manifestJson =
      _parseAndValidateManifest(manifestContent);

      // TODO 1.3.5
      // check if Schena version is suported
      _checkSchemaVersion(manifestJson);

      print('[RunCheckService] Run folder válido');
    } catch (e) {
      print('TODO: SEND UI ERROR: $e');
    }
  }

  // -------------------------
  // Funções auxiliares
  // -------------------------

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
      throw Exception(
          'artifact_manifest.json must contain a JSON object');
    }

    if (!decoded.containsKey('schemaVersion')) {
      throw Exception(
          'artifact_manifest.json missing schemaVersion');
    }

    return decoded;
  }


  void _checkSchemaVersion(Map<String, dynamic> manifestJson) {
    final schemaVersion = manifestJson['schemaVersion'];

    if (schemaVersion is! String) {
      throw Exception('schemaVersion must be a string');
    }

    if (!supportedSchemaVersions.contains(schemaVersion)) {
      throw Exception(
          'Unsupported schemaVersion: $schemaVersion');
    }
  }
}
