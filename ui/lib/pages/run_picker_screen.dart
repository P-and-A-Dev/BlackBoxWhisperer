import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/build_info_bar.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/container_loader.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/drag_and_drop.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/info_context_widget.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/picker_header.dart';
import 'package:flutter/material.dart';

class RunPickerScreen extends StatefulWidget {
  const RunPickerScreen({super.key});

  @override
  State<RunPickerScreen> createState() => _RunPickerScreenState();
}

class _RunPickerScreenState extends State<RunPickerScreen> {
  bool _showLoader = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      border: Border.all(color: Colors.white.withAlpha(25)),
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
                            onFolderDropped: (path) {
                              debugPrint("Folder dropped: $path");
                              // TODO: Trigger analysis load
                            },
                          ),
                          const InfoContextWidget(),
                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                  if (_showLoader)
                    ContainerLoader(
                      onFinished: () {
                        setState(() => _showLoader = false);
                      },
                    ),
                ],
              ),
            ),
            BuildInfoBar(),
          ],
        ),
      ),
    );
  }
}
