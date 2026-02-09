import 'package:blackbox_ui/models/artifact_status.dart';
import 'package:flutter/material.dart';

class ArtifactStatusBadge extends StatelessWidget {
  final ArtifactStatus status;

  const ArtifactStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (status) {
      ArtifactStatus.ok => ('OK', Colors.green),
      ArtifactStatus.missing => ('Missing', Colors.red),
      ArtifactStatus.mismatch => ('Mismatch', Colors.orange),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
