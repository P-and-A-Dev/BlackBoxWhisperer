import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BuildInfoBar extends StatelessWidget {
  const BuildInfoBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.hasData ? snapshot.data!.version : "1.0.0";

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 750),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Text(
              "Black Box Whisperer v$version",
              key: ValueKey(version),
              style: TextStyle(
                color: Colors.white.withAlpha(50),
              ),
            ),
          );
        },
      ),
    );
  }
}
