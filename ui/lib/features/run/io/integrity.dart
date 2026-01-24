import 'dart:io';

import 'package:ui/features/run/domain/integrity_status.dart';

import '../domain/artifact_id.dart';
import '../domain/manifest.dart';

IntegrityStatus computeIntegrityForPath(String runPath, String relativePath) {
  try {
    final file = File('$runPath/$relativePath');
    if (!file.existsSync()) {
      return const IntegrityStatus(results: {});
    }
    return const IntegrityStatus(results: {});
  } catch (_) {
    return const IntegrityStatus(results: {});
  }
}

/// TODO : Recheck Simple version: checks only "present or missing"
IntegrityStatus computeAllIntegrity(String runPath, Manifest manifest) {
  final results = <ArtifactId, IntegrityResult>{};

  for (final entry in manifest.all) {
    try {
      final file = File('$runPath/${entry.relativePath}');
      results[entry.id] = file.existsSync()
          ? IntegrityResult.ok
          : IntegrityResult.missing;
    } catch (_) {
      results[entry.id] = IntegrityResult.ioError;
    }
  }

  return IntegrityStatus(results: results);
}
