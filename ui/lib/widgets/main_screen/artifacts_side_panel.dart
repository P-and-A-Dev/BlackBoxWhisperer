import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:blackbox_ui/states/selected_artifact_provider.dart';
import 'package:blackbox_ui/utils/artifact_parser.dart';
import 'package:blackbox_ui/widgets/main_screen/artifact_list_item.dart';
import 'package:blackbox_ui/widgets/main_screen/artifacts_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtifactsSidePanel extends ConsumerWidget {
  const ArtifactsSidePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedRun = ref.watch(loadedRunProvider);
    final selectedArtifact = ref.watch(selectedArtifactProvider);

    if (loadedRun == null) {
      return Container(
        width: 280,
        color: const Color(0xFF1e1e1e),
        child: const Center(
          child: Text(
            'No run loaded',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final artifacts = parseArtifacts(
      loadedRun.manifest,
      loadedRun.runFolderPath,
    );

    return Container(
      width: 280,
      color: const Color(0xFF1e1e1e),
      child: Column(
        children: [
          const ArtifactsSectionHeader(),
          const Divider(height: 1, color: Colors.white24),
          Expanded(
            child: artifacts.isEmpty
                ? const Center(
                    child: Text(
                      'No artifacts',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: artifacts.length,
                    itemBuilder: (context, index) {
                      final artifact = artifacts[index];
                      final isSelected = selectedArtifact?.id == artifact.id;

                      return ArtifactListItem(
                        artifact: artifact,
                        isSelected: isSelected,
                        onTap: () {
                          ref.read(selectedArtifactProvider.notifier).state =
                              artifact;
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
