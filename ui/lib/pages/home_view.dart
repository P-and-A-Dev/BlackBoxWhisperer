import 'package:blackbox_ui/pages/run_picker_screen.dart';
import 'package:blackbox_ui/states/home_mode.dart';
import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeMode _mode = HomeMode.runPicker;

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
      HomeMode.main => Container(
        key: ValueKey(_mode),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
