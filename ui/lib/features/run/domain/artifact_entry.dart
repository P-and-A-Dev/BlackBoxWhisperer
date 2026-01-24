import 'artifact_id.dart';

enum ArtifactType { json, markdown }

class ArtifactEntry {
  final ArtifactId id;
  final String relativePath;
  final ArtifactType type;

  const ArtifactEntry({
    required this.id,
    required this.relativePath,
    required this.type,
  });

  factory ArtifactEntry.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String?)?.toLowerCase();
    final type = switch (typeStr) {
      'json' => ArtifactType.json,
      _ => ArtifactType.markdown,
    };

    return ArtifactEntry(
      id: json['id'] as String,
      relativePath: json['path'] as String,
      type: type,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': relativePath,
    'type': type.name,
  };
}
