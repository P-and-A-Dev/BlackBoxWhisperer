import 'artifact_id.dart';

enum IntegrityResult { ok, missing, shaMismatch, ioError }

class IntegrityStatus {
  final Map<ArtifactId, IntegrityResult> results;

  const IntegrityStatus({required this.results});

  bool get allOk => results.values.every((r) => r == IntegrityResult.ok);

  IntegrityResult of(ArtifactId id) => results[id] ?? IntegrityResult.ioError;

  IntegrityStatus copyWith({
    Map<ArtifactId, IntegrityResult>? results,
  }) {
    return IntegrityStatus(results: results ?? this.results);
  }
}
