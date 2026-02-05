import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/build_info_bar.dart';
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
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500),
      child: Padding(
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
                  ],
                ),
              ),
              BuildInfoBar(),
            ],
          ),
        ),
      ),
    );
  }
}
