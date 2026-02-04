import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerLoader extends StatefulWidget {
  const ContainerLoader({
    super.key,
  });

  @override
  State<ContainerLoader> createState() => _ContainerLoaderState();
}

class _ContainerLoaderState extends State<ContainerLoader> {
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      setState(() {
        opacity = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      opacity: opacity,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 10 * 4,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: .circular(15),
        ),
      ),
    );
  }
}
