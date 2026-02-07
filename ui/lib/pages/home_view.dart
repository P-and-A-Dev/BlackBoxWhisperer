import 'package:blackbox_ui/pages/run_picker_screen.dart';
import 'package:blackbox_ui/states/home_mode.dart';
import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeMode _mode = HomeMode.main;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return switch (_mode) {
      HomeMode.main => MainScreen(
        key: ValueKey(_mode),
      ),
      HomeMode.runPicker => RunPickerScreen(
        key: ValueKey(_mode),
      ),
    };
  }

  void changeContent(HomeMode mode) {
    setState(() {
      _mode = mode;
    });
  }
}
