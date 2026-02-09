import 'dart:io';

import 'package:blackbox_ui/models/artifact_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownArtifactViewer extends StatefulWidget {
  final ArtifactItem artifact;
  final String runFolderPath;

  const MarkdownArtifactViewer({
    super.key,
    required this.artifact,
    required this.runFolderPath,
  });

  @override
  State<MarkdownArtifactViewer> createState() => _MarkdownArtifactViewerState();
}

class _MarkdownArtifactViewerState extends State<MarkdownArtifactViewer> {
  String? _content;
  bool _isLoading = true;
  String? _error;
  bool _isRenderedMode = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void didUpdateWidget(MarkdownArtifactViewer oldWidget) {
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

      final content = await file.readAsString();

      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error reading file: $e';
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_content != null) {
      Clipboard.setData(ClipboardData(text: _content!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Content copied to clipboard'),
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
          const Icon(Icons.description, size: 20, color: Colors.white70),
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
          // Rendered / Source toggle
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2a2f38),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                _buildToggleButton('Rendered', _isRenderedMode, () {
                  setState(() => _isRenderedMode = true);
                }),
                _buildToggleButton('Source', !_isRenderedMode, () {
                  setState(() => _isRenderedMode = false);
                }),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Action buttons
          _buildActionButton(Icons.copy, 'Copy', _copyToClipboard),
          const SizedBox(width: 8),
          _buildActionButton(Icons.download, 'Download', () {
            // TODO: Implement download
          }),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0d6efd) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white60,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
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

    if (_isRenderedMode) {
      return _buildRenderedView();
    } else {
      return _buildSourceView();
    }
  }

  Widget _buildRenderedView() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Markdown(
        data: _content ?? '',
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          // Paragraphs
          p: const TextStyle(
            color: Color(0xFFe6edf3),
            fontSize: 15,
            height: 1.7,
            letterSpacing: 0.2,
          ),
          // Headers
          h1: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
          h2: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
          h3: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
          h4: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
          h5: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
          h6: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
          // Code
          code: const TextStyle(
            backgroundColor: Color(0xFF2d333b),
            color: Color(0xFF7ee787),
            fontFamily: 'monospace',
            fontSize: 13,
          ),
          codeblockDecoration: BoxDecoration(
            color: const Color(0xFF161b22),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF30363d)),
          ),
          codeblockPadding: const EdgeInsets.all(16),
          // Lists
          listBullet: const TextStyle(
            color: Color(0xFF0d6efd),
            fontSize: 15,
          ),
          listIndent: 24,
          // Blockquotes
          blockquote: const TextStyle(
            color: Color(0xFF8b949e),
            fontStyle: FontStyle.italic,
            fontSize: 15,
          ),
          blockquoteDecoration: BoxDecoration(
            color: const Color(0xFF1c2128),
            border: const Border(
              left: BorderSide(color: Color(0xFF0d6efd), width: 3),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          blockquotePadding: const EdgeInsets.all(16),
          // Links
          a: const TextStyle(
            color: Color(0xFF58a6ff),
            decoration: TextDecoration.underline,
          ),
          // Tables
          tableHead: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tableBody: const TextStyle(
            color: Color(0xFFc9d1d9),
            fontSize: 14,
          ),
          tableBorder: TableBorder.all(
            color: const Color(0xFF30363d),
            width: 1,
          ),
          tableCellsPadding: const EdgeInsets.all(12),
          // Horizontal rule
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: const Color(0xFF30363d),
                width: 1,
              ),
            ),
          ),
          // Checkboxes
          checkbox: const TextStyle(color: Color(0xFF58a6ff)),
        ),
      ),
    );
  }

  Widget _buildSourceView() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: SelectableText(
          _content ?? '',
          style: const TextStyle(
            color: Color(0xFFc9d1d9),
            fontSize: 13,
            fontFamily: 'monospace',
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
