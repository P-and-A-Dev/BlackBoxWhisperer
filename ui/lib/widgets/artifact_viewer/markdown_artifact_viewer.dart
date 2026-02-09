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
  State<MarkdownArtifactViewer> createState() =>
      _MarkdownArtifactViewerState();
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
      final file = File(
        '${widget.runFolderPath}/${widget.artifact.path}',
      );

      if (!file.existsSync()) {
        setState(() {
          _error = 'File not found: ${widget.artifact.path}';
          _isLoading = false;
        });
        return;
      }

      final text = await file.readAsString();

      setState(() {
        _content = text;
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
    if (_content == null) return;
    Clipboard.setData(ClipboardData(text: _content!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0b1220),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Color(0xFF1f2937)),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: const Color(0xFF0f172a),
      child: Row(
        children: [
          const Icon(Icons.menu_book,
              size: 20, color: Colors.white70),
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
          _buildToggle(),
          const SizedBox(width: 12),
          _buildIconButton(Icons.copy_all, 'Copy', _copyToClipboard),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF1f2937)),
      ),
      child: Row(
        children: [
          _toggleButton(
            'Rendered',
            _isRenderedMode,
                () => setState(() => _isRenderedMode = true),
          ),
          _toggleButton(
            'Source',
            !_isRenderedMode,
                () => setState(() => _isRenderedMode = false),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(
      String label,
      bool active,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color:
          active ? const Color(0xFF2563eb) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon,
      String tooltip,
      VoidCallback onTap,
      ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: Colors.white60),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2563eb)),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    return _isRenderedMode
        ? _buildRenderedView()
        : _buildSourceView();
  }

  Widget _buildRenderedView() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          child: MarkdownBody(
            data: _content ?? '',
            selectable: true,
            styleSheet: _internalDocsStyle(),
            checkboxBuilder: (checked) {
              return Icon(
                checked
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 18,
                color: checked
                    ? const Color(0xFF22c55e)
                    : Colors.white38,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSourceView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SelectableText(
        _content ?? '',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.6,
          color: Color(0xFFcbd5f5),
        ),
      ),
    );
  }

  MarkdownStyleSheet _internalDocsStyle() {
    return MarkdownStyleSheet(
      p: const TextStyle(
        fontSize: 15,
        height: 1.7,
        color: Color(0xFFe5e7eb),
      ),

      h1: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      h2: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      h3: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),

      code: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: Color(0xFFe5e7eb),
        backgroundColor: Color(0xFF020617),
      ),
      codeblockDecoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF1f2937)),
      ),
      codeblockPadding: const EdgeInsets.all(16),

      blockquote: const TextStyle(
        color: Color(0xFFc7d2fe),
        height: 1.6,
      ),
      blockquoteDecoration: BoxDecoration(
        color: const Color(0xFF0b2a4a),
        border: const Border(
          left: BorderSide(color: Color(0xFF3b82f6), width: 4),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      blockquotePadding: const EdgeInsets.all(16),

      a: const TextStyle(
        color: Color(0xFF60a5fa),
        decoration: TextDecoration.underline,
      ),

      tableBorder: TableBorder.all(
        color: const Color(0xFF1f2937),
      ),
      tableHead: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      tableBody: const TextStyle(
        color: Color(0xFFe5e7eb),
      ),
    );
  }
}
