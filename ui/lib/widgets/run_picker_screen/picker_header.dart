import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/app_text.dart';
import 'package:flutter/material.dart';

class PickerHeader extends StatelessWidget {
  const PickerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            padding: .all(17),
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: .circular(250),
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withAlpha(50),
                  AppColors.primary.withAlpha(15),
                ],
              ),
            ),
            child: FittedBox(
              child: Icon(
                Icons.folder_copy_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 18),
          AppText(
            "Open Analysis Run",
            type: .title,
            fontSize: 26,
            letterSpacing: -0.5,
          ),
          SizedBox(height: 8),
          AppText(
            "Select a run directory to visualize results.",
            type: .subTitle,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
