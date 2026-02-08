import 'package:blackbox_ui/pages/new_scan_button.dart';
import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/pulse_dots_loader.dart';
import 'package:blackbox_ui/widgets/main_screen/artifacts_section_header.dart';
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
                  Expanded(
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
                  ),
                  Expanded(
                    flex: 3,
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
