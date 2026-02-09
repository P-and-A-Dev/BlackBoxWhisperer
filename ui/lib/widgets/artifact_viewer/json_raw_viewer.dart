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

  // 🎨 Cores
  static const _defaultColor = Color(0xFFc9d1d9);
  static const _keyColor = Color(0xFFc586c0);
  static const _stringColor = Color(0xFF7ee787);
  static const _braceColor = Color(0xFFf2cc60);
  static const _numberColor = Color(0xFFffa657);
  static const _lineNumberColor = Color(0xFF6e7681);

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
        final pretty =
        const JsonEncoder.withIndent('  ').convert(jsonData);

        setState(() {
          _formattedContent = pretty;
          _isLoading = false;
        });
      } catch (_) {
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
        const SnackBar(content: Text('JSON copied')),
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
          Expanded(child: _buildContent()),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          InkWell(
            onTap: _copyToClipboard,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.copy, size: 18, color: Colors.white60),
            ),
          ),
        ],
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
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0d1117),
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
    final digits = lines.length.toString().length;

    for (var i = 0; i < lines.length; i++) {
      final number = (i + 1).toString().padLeft(digits, ' ');
      spans.add(
        TextSpan(
          text: '$number  ',
          style: const TextStyle(color: _lineNumberColor),
        ),
      );

      spans.addAll(_parseJsonLine(lines[i]));

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

    final keyMatch = keyRegex.firstMatch(line);

    if (keyMatch != null) {
      spans.addAll(_colorChars(line.substring(0, keyMatch.start)));

      spans.add(
        TextSpan(
          text: '"${keyMatch.group(1)}"',
          style: const TextStyle(color: _keyColor),
        ),
      );

      spans.add(
        const TextSpan(text: ': ', style: TextStyle(color: _defaultColor)),
      );

      final remaining = line.substring(keyMatch.end);

      if (stringValueRegex.hasMatch(': $remaining')) {
        final m = stringValueRegex.firstMatch(': $remaining')!;
        spans.add(
          TextSpan(
            text: '"${m.group(1)}"',
            style: const TextStyle(color: _stringColor),
          ),
        );
      } else if (numberRegex.hasMatch(': $remaining')) {
        final m = numberRegex.firstMatch(': $remaining')!;
        spans.add(
          TextSpan(
            text: m.group(1)!,
            style: const TextStyle(color: _numberColor),
          ),
        );
      } else if (boolNullRegex.hasMatch(': $remaining')) {
        final m = boolNullRegex.firstMatch(': $remaining')!;
        spans.add(
          TextSpan(
            text: m.group(1)!,
            style: const TextStyle(color: _numberColor),
          ),
        );
      }

      spans.addAll(_colorChars(
        remaining.replaceFirst(
          RegExp(r'^.*?"[^"]*"|^.*?\d+|^.*?(true|false|null)'),
          '',
        ),
      ));
    } else {
      spans.addAll(_colorChars(line));
    }

    return spans;
  }

  List<TextSpan> _colorChars(String text) {
    return text.characters.map((char) {
      if ('{}[]'.contains(char)) {
        return TextSpan(
          text: char,
          style: const TextStyle(color: _braceColor),
        );
      }

      if (char == '"') {
        return TextSpan(
          text: char,
          style: const TextStyle(color: _stringColor),
        );
      }

      return TextSpan(
        text: char,
        style: const TextStyle(color: _defaultColor),
      );
    }).toList();
  }
}
