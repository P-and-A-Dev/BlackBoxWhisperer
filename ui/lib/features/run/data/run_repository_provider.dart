import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/features/run/data/run_repository.dart';
import 'package:ui/features/run/state/run_context_provider.dart';

final runRepositoryProvider = Provider<RunRepository>((ref) {
  final runPath = ref.watch(runContextProvider.select((s) => s.runPath));
  final manifest = ref.watch(runContextProvider.select((s) => s.manifest));

  if (runPath == null || manifest == null) {
    throw StateError("Run not ready");
  }

  return RunRepository(
    runPath: runPath,
    manifest: manifest,
  );
});
