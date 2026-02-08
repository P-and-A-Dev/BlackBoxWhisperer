import 'package:blackbox_ui/models/run_load_result.dart';
import 'package:blackbox_ui/run_picker_checker/run_check_service.dart';
import 'package:blackbox_ui/states/home_mode.dart';
import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/utils/error_helper.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/build_info_bar.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/drag_and_drop.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/info_context_widget.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/picker_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RunPickerScreen extends ConsumerStatefulWidget {
  final Function(HomeMode)? onNavigate;

  const RunPickerScreen({super.key, this.onNavigate});

  @override
  ConsumerState<RunPickerScreen> createState() => _RunPickerScreenState();
}

class _RunPickerScreenState extends ConsumerState<RunPickerScreen> {
  double _opacity = 0;
  bool _isLoading = false;
  final _runCheckService = RunCheckService();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() => _opacity = 1);
    });
  }

  Future<void> _handleFolderDropped(String folderPath) async {
    setState(() => _isLoading = true);

    try {
      final result = await _runCheckService.loadRunFolder(folderPath);

      if (!mounted) return;

      switch (result) {
        case RunLoadSuccess(:final runFolderPath, :final manifest):
          ref.read(loadedRunProvider.notifier).state = LoadedRunState(
            runFolderPath: runFolderPath,
            manifest: manifest,
          );

          if (widget.onNavigate != null) {
            widget.onNavigate!(HomeMode.main);
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Run loaded: ${manifest.runId}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }

        case RunLoadError():
          if (mounted) {
            showRunLoadError(context, result);
          }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 10 * 4,
                          constraints: const BoxConstraints(maxWidth: 600),
                          decoration: BoxDecoration(
                            color: AppColors.foreground,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withAlpha(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(100),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const PickerHeader(),
                                DragAndDrop(
                                  onFolderDropped: _handleFolderDropped,
                                ),
                                const InfoContextWidget(),
                                const SizedBox(height: 36),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const BuildInfoBar(),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(127),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading run...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
