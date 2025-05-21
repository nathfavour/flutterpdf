import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/pdf_document_model.dart';

class PdfDashboardScreen extends StatefulWidget {
  const PdfDashboardScreen({super.key});

  @override
  State<PdfDashboardScreen> createState() => _PdfDashboardScreenState();
}

class _PdfDashboardScreenState extends State<PdfDashboardScreen> {
  List<PdfDocumentModel> recentPdfs = [];

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final doc = PdfDocumentModel(path: result.files.single.path!);
      setState(() {
        recentPdfs.insert(0, doc);
      });
      Navigator.pushNamed(context, '/preview', arguments: doc);
    }
  }

  void _openPdf(PdfDocumentModel doc) {
    Navigator.pushNamed(context, '/preview', arguments: doc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Dashboard')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Pick a PDF'),
              onPressed: _openFilePicker,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Recent PDFs',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child:
                recentPdfs.isEmpty
                    ? const Center(child: Text('No recent PDFs.'))
                    : ListView.builder(
                      itemCount: recentPdfs.length,
                      itemBuilder: (context, index) {
                        final doc = recentPdfs[index];
                        return ListTile(
                          leading: const Icon(Icons.picture_as_pdf),
                          title: Text(doc.name),
                          subtitle: Text(doc.path),
                          onTap: () => _openPdf(doc),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
