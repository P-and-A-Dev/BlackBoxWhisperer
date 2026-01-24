import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/features/run/data/run_repository.dart';
import 'package:ui/features/run/state/run_context_state.dart';

import '../domain/integrity_status.dart';
import '../io/run_fs.dart';

class RunContextNotifier extends Notifier<RunContextState> {
  @override
  RunContextState build() => const RunContextState.idle();

  Future<void> loadRun(String path) async {
    state = state.copyWith(status: RunStatus.loading);

    try {
      final manifest = await loadManifest(path);

      state = RunContextState(
        status: RunStatus.ready,
        runPath: path,
        manifest: manifest,
      );
    } catch (_) {
      state = state.copyWith(status: RunStatus.error);
    }
  }

  Future<IntegrityStatus> computeIntegrityIfNeeded(
    RunRepository repository,
  ) async {
    if (state.integrityStatus != null) {
      return state.integrityStatus!;
    }

    final integrity = await Future(() => repository.checkAllIntegrity());
    state = state.copyWith(integrityStatus: integrity);
    return integrity;
  }
}
