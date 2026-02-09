import 'package:blackbox_ui/models/artifact_manifest.dart';

sealed class RunLoadResult {}

class RunLoadSuccess extends RunLoadResult {
  final String runFolderPath;
  final ArtifactManifest manifest;

  RunLoadSuccess(this.runFolderPath, this.manifest);
}

class RunLoadError extends RunLoadResult {
  final String message;
  final RunLoadErrorType type;

  RunLoadError(this.message, this.type);
}

enum RunLoadErrorType {
  folderNotFound,
  folderNotAccessible,
  manifestNotFound,
  manifestNotReadable,
  manifestInvalidJson,
  manifestInvalidStructure,
  manifestMissingSchemaVersion,
  manifestUnsupportedVersion,
}
