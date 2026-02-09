import 'package:blackbox_ui/models/artifact_status.dart';
import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:blackbox_ui/states/selected_artifact_provider.dart';
import 'package:blackbox_ui/widgets/artifact_viewer/json_raw_viewer.dart';
import 'package:blackbox_ui/widgets/artifact_viewer/markdown_artifact_viewer.dart';
import 'package:blackbox_ui/widgets/gemini_insights_panel.dart';
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

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            Container(
              color: const Color(0xFF1e2228),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.purple,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.folder_open, size: 20),
                    text: 'Artifacts',
                  ),
                  Tab(
                    icon: Icon(Icons.psychology, size: 20),
                    text: 'AI Insights',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const ArtifactsSidePanel(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildArtifactViewer(selectedArtifact, loadedRun),
                        const GeminiInsightsPanel(),
                      ],
                    ),
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
      return Container(
        color: const Color(0xFF1a1d23),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 120,
                color: Colors.white.withAlpha(25),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Artifact Selected',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select an artifact from the sidebar to inspect its\ndetails and verification status.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha(153),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (selectedArtifact.type == ArtifactType.markdown) {
      return MarkdownArtifactViewer(
        artifact: selectedArtifact,
        runFolderPath: loadedRun.runFolderPath,
      );
    }

    return JsonRawViewer(
      artifact: selectedArtifact,
      runFolderPath: loadedRun.runFolderPath,
    );
  }
}
