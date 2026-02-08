import 'package:blackbox_ui/models/run_load_result.dart';
import 'package:flutter/material.dart';

String getErrorMessage(RunLoadError error) {
  switch (error.type) {
    case RunLoadErrorType.folderNotFound:
      return '📁 Folder not found\n\nThe selected folder does not exist.';
    case RunLoadErrorType.folderNotAccessible:
      return '🔒 Folder not accessible\n\nCannot access the selected folder. Check permissions.';
    case RunLoadErrorType.manifestNotFound:
      return '📄 Manifest not found\n\nThe folder does not contain an artifact_manifest.json file.';
    case RunLoadErrorType.manifestNotReadable:
      return '❌ Cannot read manifest\n\nThe artifact_manifest.json file cannot be read.';
    case RunLoadErrorType.manifestInvalidJson:
      return '⚠️ Invalid JSON\n\nThe artifact_manifest.json file contains invalid JSON.';
    case RunLoadErrorType.manifestInvalidStructure:
      return '🔧 Invalid structure\n\nThe manifest does not have the expected structure.';
    case RunLoadErrorType.manifestMissingSchemaVersion:
      return '📋 Missing schema version\n\nThe manifest is missing the schemaVersion field.';
    case RunLoadErrorType.manifestUnsupportedVersion:
      return '🔄 Unsupported version\n\n${error.message}';
  }
}

void showRunLoadError(BuildContext context, RunLoadError error) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cannot Load Run'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getErrorMessage(error),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            'Details: ${error.message}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
