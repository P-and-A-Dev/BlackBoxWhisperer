import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/run_repository_provider.dart';
import '../domain/artifact_id.dart';
import 'run_context_provider.dart';
import 'run_context_state.dart';

final artifactContentProvider = FutureProvider.family<String, ArtifactId>((
  ref,
  id,
) async {
  final run = ref.watch(runContextProvider);

  if (run.status != RunStatus.ready) {
    throw StateError("Run not ready");
  }

  final repository = ref.watch(runRepositoryProvider);

  ref.keepAlive();

  return repository.readArtifactText(id);
});
