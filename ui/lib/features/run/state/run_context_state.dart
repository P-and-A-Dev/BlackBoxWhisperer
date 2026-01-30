import 'package:blackbox_ui/features/run/domain/integrity_status.dart';
import 'package:blackbox_ui/features/run/domain/manifest.dart';

enum RunStatus { idle, loading, ready, error }

class RunContextState {
  final RunStatus status;
  final String? runPath;
  final Manifest? manifest;
  final IntegrityStatus? integrityStatus;

  const RunContextState({
    required this.status,
    this.runPath,
    this.manifest,
    this.integrityStatus,
  });

  const RunContextState.idle()
    : status = RunStatus.idle,
      runPath = null,
      manifest = null,
      integrityStatus = null;

  RunContextState copyWith({
    RunStatus? status,
    String? runPath,
    Manifest? manifest,
    IntegrityStatus? integrityStatus,
  }) {
    return RunContextState(
      status: status ?? this.status,
      runPath: runPath ?? this.runPath,
      manifest: manifest ?? this.manifest,
      integrityStatus: integrityStatus ?? this.integrityStatus,
    );
  }
}
