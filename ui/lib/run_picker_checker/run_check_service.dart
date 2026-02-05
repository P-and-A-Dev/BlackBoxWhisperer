import 'dart:io';

class RunCheckService {
  static const supportedSchemaVersions = ['1.0', '1.1'];

  /// Ponto de entrada único.
  /// Valida uma pasta de run.
  Future<void> checkRunFolder(String runFolderPath) async {
    try {
      // checck if the folder exists and is acessable in the private funncition _checkRunFolderAccessible
      await _checkRunFolderAccessible(runFolderPath);

      // TODO 1.3.2
      // Verificar a presença do arquivo artifact_manifest.json

      // TODO 1.3.3
      // Ler o arquivo manifest de forma assíncrona

      // TODO 1.3.4
      // Fazer o parse do JSON e validar a estrutura mínima

      // TODO 1.3.5
      // Verificar se a schemaVersion é suportada

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
      // Força acesso real ao filesystem
      await directory.list(followLinks: false).first;
    } catch (_) {
      throw Exception('Run folder is not accessible');
    }
  }
}
