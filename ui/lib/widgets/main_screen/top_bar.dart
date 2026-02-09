import 'package:blackbox_ui/pages/settings_page.dart';
import 'package:blackbox_ui/states/loaded_run_provider.dart';
import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_text_type.dart';

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedRun = ref.watch(loadedRunProvider);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
            width: 1.5,
          ),
        ),
        color: AppColors.secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary.withAlpha(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(width: 24),
            AppText(
              "Black Box Whisperer",
              type: AppTextType.title,
              fontSize: 23,
            ),
            SizedBox(width: 12),
            AppText("/", type: AppTextType.subTitle, fontSize: 23),
            SizedBox(width: 12),
            if (loadedRun != null) ...[
              AppText(
                loadedRun.manifest.adapter,
                type: AppTextType.title,
                fontSize: 20,
                color: AppColors.primary,
              ),
              SizedBox(width: 12),
              AppText("/", type: AppTextType.subTitle, fontSize: 23),
              SizedBox(width: 12),
              AppText(
                loadedRun.manifest.runId,
                type: AppTextType.subTitle,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ] else
              AppText(
                "No Run Loaded",
                type: AppTextType.subTitle,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              icon: Icon(Icons.more_vert_rounded),
              color: Colors.white.withAlpha(125),
              tooltip: 'Settings',
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.help_rounded),
              color: Colors.white.withAlpha(125),
            ),
          ],
        ),
      ),
    );
  }
}
