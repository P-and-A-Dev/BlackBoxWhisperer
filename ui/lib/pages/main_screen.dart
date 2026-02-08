import 'package:blackbox_ui/models/artifact_status.dart';
import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:blackbox_ui/states/selected_artifact_provider.dart';
import 'package:blackbox_ui/widgets/artifact_viewer/markdown_artifact_viewer.dart';
import 'package:blackbox_ui/widgets/common/pulse_dots_loader.dart';
import 'package:blackbox_ui/widgets/main_screen/artifacts_side_panel.dart';
import 'package:blackbox_ui/widgets/main_screen/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/artifact_item_model.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedArtifact = ref.watch(selectedArtifactProvider);
    final loadedRun = ref.watch(loadedRunProvider);

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const TopBar(),
            Expanded(
              child: Row(
                children: [
                  const ArtifactsSidePanel(),
                  Expanded(
                    child: _buildArtifactViewer(selectedArtifact, loadedRun),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtifactViewer(
    ArtifactItem? selectedArtifact,
    LoadedRunState? loadedRun,
  ) {
    if (selectedArtifact == null || loadedRun == null) {
      return const Center(
        child: PulseDotsLoader(size: 150),
      );
    }

    if (selectedArtifact.type == ArtifactType.markdown) {
      return MarkdownArtifactViewer(
        artifact: selectedArtifact,
        runFolderPath: loadedRun.runFolderPath,
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.code, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'JSON viewer coming soon',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
