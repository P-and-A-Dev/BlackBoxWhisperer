import 'package:blackbox_ui/models/artifact_status.dart';

class ArtifactItem {
  final String id;
  final String path;
  final String hash;
  final ArtifactType type;
  final ArtifactStatus status;

  ArtifactItem({
    required this.id,
    required this.path,
    required this.hash,
    required this.type,
    required this.status,
  });
}
