import 'artifact_entry.dart';
import 'artifact_id.dart';

class Manifest {
  final Map<ArtifactId, ArtifactEntry> artifacts;

  const Manifest({required this.artifacts});

  bool containsArtifact(ArtifactId id) => artifacts.containsKey(id);

  ArtifactEntry entryOf(ArtifactId id) {
    final entry = artifacts[id];
    if (entry == null) {
      throw StateError('Artifact not declared in manifest: $id');
    }
    return entry;
  }

  Iterable<ArtifactEntry> get all => artifacts.values;

  factory Manifest.fromJson(Map<String, dynamic> json) {
    final list = (json['artifacts'] as List<dynamic>? ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();

    final map = <ArtifactId, ArtifactEntry>{};
    for (final item in list) {
      final entry = ArtifactEntry.fromJson(item);
      map[entry.id] = entry;
    }

    return Manifest(artifacts: map);
  }

  Map<String, dynamic> toJson() => {
    'artifacts': artifacts.values.map((e) => e.toJson()).toList(),
  };
}
