import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/pdf_viewer_widget.dart';
import '../models/pdf_document_model.dart';

class PdfHomeScreen extends StatefulWidget {
  const PdfHomeScreen({super.key});

  @override
  State<PdfHomeScreen> createState() => _PdfHomeScreenState();
}

class _PdfHomeScreenState extends State<PdfHomeScreen> {
  PdfDocumentModel? _pdfDoc;
  bool _loadingText = false;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfDoc = PdfDocumentModel(path: result.files.single.path!);
      });
    }
  }

  Future<void> _extractText() async {
    if (_pdfDoc == null) return;
    setState(() {
      _loadingText = true;
    });
    await _pdfDoc!.extractText();
    setState(() {
      _loadingText = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _pickPDF,
            tooltip: 'Pick PDF',
          ),
          if (_pdfDoc != null)
            IconButton(
              icon: const Icon(Icons.text_snippet),
              onPressed: _extractText,
              tooltip: 'Extract Text',
            ),
        ],
      ),
      body:
          _pdfDoc == null
              ? const Center(child: Text('No PDF selected.'))
              : Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: PdfViewerWidget(pdfPath: _pdfDoc!.path),
                  ),
                  if (_loadingText)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  if (_pdfDoc!.text != null)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Text(_pdfDoc!.text!),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}
