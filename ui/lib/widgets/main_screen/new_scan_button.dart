import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/app_text.dart';
import 'package:flutter/material.dart';

class NewScanButton extends StatelessWidget {
  const NewScanButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Material(
        borderRadius: .circular(15),
        color: AppColors.primary,
        child: InkWell(
          splashColor: Colors.blue,
          borderRadius: .circular(15),
          onTap: () {
            debugPrint("New Scan");
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: .circular(15),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      Icons.add_circle_rounded,
                      color: Colors.white.withAlpha(225),
                    ),
                    SizedBox(width: 12),
                    AppText(
                      "New Scan",
                      type: .subTitle,
                      fontSize: 20,
                      color: Colors.white.withAlpha(225),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
