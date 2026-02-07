import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/app_text.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xFF111318),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: .circular(10),
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
            AppText("Black Box Whisperer", type: .title, fontSize: 23),
            SizedBox(width: 12),
            AppText("/", type: .subTitle, fontSize: 23),
            SizedBox(width: 12),
            AppText(
              "Local Session",
              type: .subTitle,
              fontSize: 20,
              fontWeight: .w400,
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_rounded),
              color: Colors.white.withAlpha(125),
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
