import 'package:blackbox_ui/widgets/main_screen/new_scan_button.dart';
import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/pulse_dots_loader.dart';
import 'package:blackbox_ui/widgets/main_screen/artifacts_section_header.dart';
import 'package:flutter/material.dart';

class ArtifactsSidePanel extends StatelessWidget {
  const ArtifactsSidePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          border: Border(
            right: BorderSide(
              color: Colors.white10,
              width: 1.5,
            ),
          ),
        ),
        child: Column(
          children: [
            ArtifactsSectionHeader(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white10,
                      width: 1.5,
                    ),
                  ),
                ),
                child: Center(
                  child: const PulseDotsLoader(size: 150),
                ),
              ),
            ),
            NewScanButton(),
          ],
        ),
      ),
    );
  }
}
