import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_text_type.dart';

class AppText extends Text {
  final AppTextType type;
  final double? fontSize;
  final double? letterSpacing;
  final Color? color;

  const AppText(
    super.data, {
    super.key,
    this.type = .subTitle,
    this.fontSize,
    this.letterSpacing,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data!,
      textAlign: .center,
      style: GoogleFonts.inter(
        color:
            color ??
            Colors.white.withAlpha(
              type == .title
                  ? 255
                  : type == .subTitle
                  ? 125
                  : 50,
            ),
        fontSize: fontSize,
        letterSpacing: type == .title ? -0.5 : letterSpacing ?? 0,
        fontWeight: type == .title ? .w600 : .w400,
      ),
    );
  }
}
