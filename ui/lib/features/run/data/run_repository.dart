import 'package:ui/features/run/domain/integrity_status.dart';

import '../domain/artifact_id.dart';
import '../domain/manifest.dart';
import '../io/integrity.dart';
import '../io/run_fs.dart';

class RunRepository {
  final String runPath;
  final Manifest manifest;

  RunRepository({
    required this.runPath,
    required this.manifest,
  });

  String readArtifactText(ArtifactId id) {
    final entry = manifest.entryOf(id);
    return readTextFile(runPath, entry.relativePath);
  }

  Map<String, dynamic> readArtifactJson(ArtifactId id) {
    final entry = manifest.entryOf(id);
    return readJsonFile(runPath, entry.relativePath);
  }

  IntegrityStatus checkIntegrity(ArtifactId id) {
    final entry = manifest.entryOf(id);
    return computeAllIntegrity(runPath, Manifest(artifacts: {id: entry}));
  }

  IntegrityStatus checkAllIntegrity() {
    return computeAllIntegrity(runPath, manifest);
  }
}
