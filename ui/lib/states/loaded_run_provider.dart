import 'package:blackbox_ui/models/artifact_manifest.dart';
import 'package:flutter_riverpod/legacy.dart';

class LoadedRunState {
  final String runFolderPath;
  final ArtifactManifest manifest;

  LoadedRunState({
    required this.runFolderPath,
    required this.manifest,
  });
}

final loadedRunProvider = StateProvider<LoadedRunState?>((ref) => null);
