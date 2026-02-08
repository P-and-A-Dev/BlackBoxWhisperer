import 'package:blackbox_ui/widgets/common/pulse_dots_loader.dart';
import 'package:blackbox_ui/widgets/main_screen/artifacts_side_panel.dart';
import 'package:blackbox_ui/widgets/main_screen/top_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TopBar(),
            Expanded(
              child: Row(
                children: [
                  const ArtifactsSidePanel(),
                  Expanded(
                    child: Center(
                      child: const PulseDotsLoader(size: 150),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
