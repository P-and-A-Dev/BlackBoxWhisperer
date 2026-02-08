import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArtifactsSectionHeader extends StatelessWidget {
  const ArtifactsSectionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      "ARTIFACTS",
                      type: .title,
                      color: Colors.white.withAlpha(175),
                      fontSize: 22,
                    ),
                    AppText(
                      "Static Analysis Results",
                      type: .subTitle,
                      fontSize: 20,
                      fontWeight: .w300,
                    ),
                  ],
                ),
                SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: .circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFF20252E),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withAlpha(75),
                    ),
                    hintText: "Search",
                    hintStyle: GoogleFonts.inter(
                      color: Colors.white.withAlpha(75),
                      fontWeight: .w400,
                    ),
                  ),
                  cursorColor: AppColors.primary,
                  style: GoogleFonts.inter(
                    color: Colors.white.withAlpha(200),
                    fontWeight: .w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
