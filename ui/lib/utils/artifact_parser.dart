import 'dart:io';

import 'package:blackbox_ui/models/artifact_item_model.dart';
import 'package:blackbox_ui/models/artifact_manifest.dart';
import 'package:blackbox_ui/models/artifact_status.dart';

List<ArtifactItem> parseArtifacts(
  ArtifactManifest manifest,
  String runFolderPath,
) {
  final artifacts = <ArtifactItem>[];

  manifest.outputs.forEach((id, outputData) {
    if (outputData == null || outputData is! Map<String, dynamic>) return;

    final path = outputData['path'];
    final hash = outputData['hash'] ?? outputData['sha256'];

    if (path == null || hash == null) return;

    final type = _determineType(path as String);

    final fullPath = '$runFolderPath/$path';
    final file = File(fullPath);
    final status = file.existsSync()
        ? ArtifactStatus.ok
        : ArtifactStatus.missing;

    artifacts.add(
      ArtifactItem(
        id: id,
        path: path,
        hash: hash as String,
        type: type,
        status: status,
      ),
    );
  });

  artifacts.sort((a, b) => a.id.compareTo(b.id));

  return artifacts;
}

ArtifactType _determineType(String path) {
  if (path.endsWith('.md')) {
    return ArtifactType.markdown;
  } else if (path.endsWith('.json')) {
    return ArtifactType.json;
  } else {
    return ArtifactType.json;
  }
}
