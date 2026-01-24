import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/features/run/state/selected_artifact_notifier.dart';

final selectedArtifactIdProvider =
    NotifierProvider<SelectedArtifactNotifier, String?>(
      SelectedArtifactNotifier.new,
    );
