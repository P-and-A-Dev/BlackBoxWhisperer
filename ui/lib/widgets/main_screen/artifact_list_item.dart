import 'package:blackbox_ui/models/artifact_item_model.dart';
import 'package:blackbox_ui/models/artifact_status.dart';
import 'package:blackbox_ui/widgets/main_screen/artifact_status_badge.dart';
import 'package:flutter/material.dart';

class ArtifactListItem extends StatelessWidget {
  final ArtifactItem artifact;
  final bool isSelected;
  final VoidCallback onTap;

  const ArtifactListItem({
    super.key,
    required this.artifact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = artifact.type == ArtifactType.markdown
        ? Icons.description
        : Icons.code;

    return Material(
      color: isSelected ? Colors.blue.withAlpha(30) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artifact.id,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    ArtifactStatusBadge(status: artifact.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
