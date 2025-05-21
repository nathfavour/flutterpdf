import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'pdf_renderer_linux.dart';

class PdfViewerLinux extends StatefulWidget {
  final String pdfPath;
  const PdfViewerLinux({super.key, required this.pdfPath});

  @override
  State<PdfViewerLinux> createState() => _PdfViewerLinuxState();
}

class _PdfViewerLinuxState extends State<PdfViewerLinux> {
  late PdfRendererLinux _renderer;
  int _pageCount = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _renderer = PdfRendererLinux(widget.pdfPath);
    _initPdf();
  }

  Future<void> _initPdf() async {
    try {
      final count = await _renderer.getPageCount();
      setState(() {
        _pageCount = count;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load PDF: $e';
        _loading = false;
      });
    }
  }

  Future<Widget> _buildPage(int index) async {
    try {
      Uint8List imageBytes = await _renderer.renderPage(index);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Image.memory(imageBytes),
      );
    } catch (e) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Failed to render page ${index + 1}: $e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    return ListView.builder(
      itemCount: _pageCount,
      itemBuilder: (context, index) {
        return FutureBuilder<Widget>(
          future: _buildPage(index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return snapshot.data ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
