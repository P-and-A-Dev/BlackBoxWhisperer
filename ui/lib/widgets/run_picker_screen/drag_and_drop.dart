import 'package:blackbox_ui/utils/app_colors.dart';
import 'package:blackbox_ui/utils/app_text_type.dart';
import 'package:blackbox_ui/widgets/common/app_text.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DragAndDrop extends StatefulWidget {
  final Function(String path)? onFolderDropped;

  const DragAndDrop({
    super.key,
    this.onFolderDropped,
  });

  @override
  State<DragAndDrop> createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  bool _isDragging = false;
  int alpha = 15;
  bool _isExplorerOpened = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
      child: DropTarget(
        onDragDone: (detail) {
          setState(() {
            _isDragging = false;
          });
          if (detail.files.isNotEmpty) {
            final XFile file = detail.files.first;
            debugPrint("Dropped path: ${file.path}");
            widget.onFolderDropped?.call(file.path);
          }
        },
        onDragEntered: (detail) {
          setState(() {
            _isDragging = true;
          });
        },
        onDragExited: (detail) {
          setState(() {
            _isDragging = false;
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) {
            if (alpha == 15) {
              setState(() {
                alpha = 40;
              });
            }
          },
          onExit: (event) {
            if (alpha > 15) {
              setState(() {
                alpha = 15;
              });
            }
          },
          child: GestureDetector(
            onTap: () async {
              setState(() {
                alpha = 75;
              });
              if (!_isExplorerOpened) {
                _isExplorerOpened = true;
                debugPrint("Open file picker");
                Future.delayed(Duration(milliseconds: 100)).then(
                  (value) {
                    setState(() {
                      alpha = 40;
                    });
                  },
                );
                String? selectedDirectory = await FilePicker.platform
                    .getDirectoryPath();

                if (selectedDirectory != null) {
                  print("Directory selected : $selectedDirectory");
                } else {
                  _isExplorerOpened = false;
                }
              }
            },
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(15),
                color: _isDragging
                    ? AppColors.primary
                    : AppColors.primary.withAlpha(100),
                strokeWidth: _isDragging ? 4.0 : 2.5,
                dashPattern: [10, 5],
              ),
              child: AnimatedContainer(
                height: 250,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _isDragging
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(alpha),
                      blurRadius: 25,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                duration: Duration(milliseconds: 250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      _isDragging
                          ? Icons.folder_open_rounded
                          : Icons.create_new_folder_rounded,
                      color: AppColors.primary,
                      size: _isDragging ? 40 : 30,
                    ),
                    Center(
                      child: Wrap(
                        direction: Axis.vertical,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppText(
                            _isDragging
                                ? "Drop folder to analyze"
                                : "Drag and drop folder here",
                            type: AppTextType.title,
                            fontSize: 16,
                            color: Colors.white.withAlpha(200),
                          ),
                          if (!_isDragging)
                            AppText(
                              "or browse your local files",
                              type: AppTextType.subTitle,
                            ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.folder_rounded,
                                color: Colors.white,
                              ),
                              FittedBox(
                                child: Text(
                                  "Open Run Folder",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
