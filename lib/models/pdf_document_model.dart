import 'package:pdf_text/pdf_text.dart';

class PdfDocumentModel {
  final String path;
  String? text;
  String get name => path.split('/').last;

  PdfDocumentModel({required this.path});

  Future<void> extractText() async {
    final doc = await PDFDoc.fromPath(path);
    text = await doc.text;
  }
}
