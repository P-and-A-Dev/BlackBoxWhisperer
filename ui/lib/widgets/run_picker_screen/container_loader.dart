import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerLoader extends StatefulWidget {
  final VoidCallback onFinished;

  const ContainerLoader({super.key, required this.onFinished});

  @override
  State<ContainerLoader> createState() => _ContainerLoaderState();
}

class _ContainerLoaderState extends State<ContainerLoader> {
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => opacity = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      opacity: opacity,
      onEnd: widget.onFinished,
      child: Container(
        width: MediaQuery.of(context).size.width / 10 * 4,
        decoration: BoxDecoration(
          border: .all(color: AppColors.background),
          color: AppColors.background,
        ),
      ),
    );
  }
}
