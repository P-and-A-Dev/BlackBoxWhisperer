import 'package:blackbox_ui/widgets/run_picker_screen/container_loader.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/picker_header.dart';
import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/run_picker_screen/build_info_bar.dart';
import 'package:flutter/material.dart';

class RunPickerScreen extends StatefulWidget {
  const RunPickerScreen({super.key});

  @override
  State<RunPickerScreen> createState() => _RunPickerScreenState();
}

class _RunPickerScreenState extends State<RunPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 10 * 4,
                    decoration: BoxDecoration(
                      color: AppColors.foreground,
                      borderRadius: .circular(15),
                      border: Border.all(color: Colors.white.withAlpha(25)),
                    ),
                    child: Column(
                      children: [
                        PickerHeader(),
                      ],
                    ),
                  ),
                  ContainerLoader(),
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
