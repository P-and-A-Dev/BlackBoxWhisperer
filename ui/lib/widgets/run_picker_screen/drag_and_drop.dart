import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/widgets/common/app_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DragAndDrop extends StatelessWidget {
  const DragAndDrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: 48, vertical: 12),
      child: MouseRegion(
        onHover: (_) => debugPrint("hover zone"),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            print("test");
          },
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: .circular(15),
              color: AppColors.primary.withAlpha(100),
              strokeWidth: 2.5,
              dashPattern: [10, 5],
            ),
            child: Container(
              height: 250,
              padding: .symmetric(vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(15),
                    blurRadius: 25,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                mainAxisAlignment: .spaceEvenly,
                children: [
                  Icon(
                    Icons.create_new_folder_rounded,
                    color: AppColors.primary,
                    size: 30,
                  ),
                  Center(
                    child: Wrap(
                      direction: .vertical,
                      alignment: .center,
                      crossAxisAlignment: .center,
                      children: [
                        AppText(
                          "Drag and drop folder here",
                          type: .title,
                          fontSize: 16,
                          color: Colors.white.withAlpha(200),
                        ),
                        AppText("or browse your local files", type: .subTitle),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: .circular(10),
                        color: AppColors.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: .spaceEvenly,
                          children: [
                            Icon(Icons.folder_rounded, color: Colors.white),
                            FittedBox(
                              child: Text(
                                "Open Run Folder",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: .w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
