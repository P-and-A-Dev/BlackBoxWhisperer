import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedArtifactNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String artifactId) {
    state = artifactId;
  }

  void clear() {
    state = null;
  }
}
