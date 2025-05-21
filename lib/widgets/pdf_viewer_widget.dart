import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'pdf_viewer_linux.dart';

class PdfViewerWidget extends StatefulWidget {
  final String pdfPath;
  const PdfViewerWidget({super.key, required this.pdfPath});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return PdfViewerLinux(pdfPath: widget.pdfPath);
    }
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.bookmark, color: Colors.white),
                  tooltip: 'Bookmark',
                  onPressed: () {
                    _pdfViewerKey.currentState?.openBookmarkView();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SfPdfViewer.file(File(widget.pdfPath), key: _pdfViewerKey),
          ),
        ],
      ),
    );
  }
}
