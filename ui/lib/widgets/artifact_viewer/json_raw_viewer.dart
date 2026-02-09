import 'dart:convert';
import 'dart:io';

import 'package:blackbox_ui/models/artifact_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonRawViewer extends StatefulWidget {
  final ArtifactItem artifact;
  final String runFolderPath;

  const JsonRawViewer({
    super.key,
    required this.artifact,
    required this.runFolderPath,
  });

  @override
  State<JsonRawViewer> createState() => _JsonRawViewerState();
}

class _JsonRawViewerState extends State<JsonRawViewer> {
  String? _formattedContent;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void didUpdateWidget(JsonRawViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.artifact.id != widget.artifact.id) {
      _loadContent();
    }
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final filePath = '${widget.runFolderPath}/${widget.artifact.path}';
      final file = File(filePath);

      if (!file.existsSync()) {
        setState(() {
          _error = 'File not found: ${widget.artifact.path}';
          _isLoading = false;
        });
        return;
      }

      final rawContent = await file.readAsString();

      try {
        final jsonData = jsonDecode(rawContent);
        final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);

        setState(() {
          _formattedContent = prettyJson;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _formattedContent = rawContent;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error reading file: $e';
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_formattedContent != null) {
      Clipboard.setData(ClipboardData(text: _formattedContent!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('JSON copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1d23),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: const Color(0xFF1e2228),
      child: Row(
        children: [
          const Icon(Icons.code, size: 20, color: Colors.white70),
          const SizedBox(width: 12),
          Text(
            widget.artifact.path,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2a2f38),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'RAW',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildActionButton(Icons.copy, 'Copy', _copyToClipboard),
          const SizedBox(width: 8),
          _buildActionButton(Icons.download, 'Download', () {
            // TODO: Implement download
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.white60),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0d1117),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildColoredJson(_formattedContent ?? ''),
        ),
      ),
    );
  }

  Widget _buildColoredJson(String json) {
    final spans = <TextSpan>[];
    final lines = json.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      spans.addAll(_parseJsonLine(line));
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return SelectableText.rich(
      TextSpan(children: spans),
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.6,
      ),
    );
  }

  List<TextSpan> _parseJsonLine(String line) {
    final spans = <TextSpan>[];

    final keyRegex = RegExp(r'"([^"]+)"\s*:');
    final stringValueRegex = RegExp(r':\s*"([^"]*)"');
    final numberRegex = RegExp(r':\s*(-?\d+\.?\d*)');
    final boolNullRegex = RegExp(r':\s*(true|false|null)');

    var currentIndex = 0;
    final key = keyRegex.firstMatch(line);

    if (key != null) {
      if (key.start > 0) {
        spans.add(
          TextSpan(
            text: line.substring(0, key.start),
            style: const TextStyle(color: Color(0xFFc9d1d9)),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: '"${key.group(1)}"',
          style: const TextStyle(color: Color(0xFF79c0ff)),
        ),
      );

      currentIndex = key.end - 1;
      spans.add(
        TextSpan(
          text: ':',
          style: const TextStyle(color: Color(0xFFc9d1d9)),
        ),
      );

      final remaining = line.substring(currentIndex + 1);

      if (stringValueRegex.hasMatch(remaining)) {
        final value = stringValueRegex.firstMatch(remaining);
        if (value != null) {
          spans.add(
            TextSpan(
              text: ' "${value.group(1)}"',
              style: const TextStyle(color: Color(0xFF7ee787)),
            ),
          );
          currentIndex = line.length - remaining.length + value.end;
        }
      } else if (numberRegex.hasMatch(remaining)) {
        final value = numberRegex.firstMatch(remaining);
        if (value != null) {
          spans.add(
            TextSpan(
              text: ' ${value.group(1)}',
              style: const TextStyle(color: Color(0xFFffa657)),
            ),
          );
          currentIndex = line.length - remaining.length + value.end;
        }
      } else if (boolNullRegex.hasMatch(remaining)) {
        final value = boolNullRegex.firstMatch(remaining);
        if (value != null) {
          spans.add(
            TextSpan(
              text: ' ${value.group(1)}',
              style: const TextStyle(color: Color(0xFFffa657)),
            ),
          );
          currentIndex = line.length - remaining.length + value.end;
        }
      }

      if (currentIndex < line.length) {
        spans.add(
          TextSpan(
            text: line.substring(currentIndex),
            style: const TextStyle(color: Color(0xFFc9d1d9)),
          ),
        );
      }
    } else {
      spans.add(
        TextSpan(
          text: line,
          style: const TextStyle(color: Color(0xFFc9d1d9)),
        ),
      );
    }

    return spans;
  }
}
