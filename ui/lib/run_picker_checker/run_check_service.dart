class RunCheckService {
  static const supportedSchemaVersions = ['1.0', '1.1'];

  /// Ponto de entrada único.
  /// Valida uma pasta de run.
  Future<void> checkRunFolder(String runFolderPath) async {
    try {
      // TODO 1.3.1
      // Verificar se a pasta existe e é acessível

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

  // TODO: Adicionar aqui funções privadas se necessário
  // (ex: _checkFolderAccessible, _readManifest, etc.)
}
