import 'dart:typed_data';
import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import 'pdf_native_ffi.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class PdfRendererLinux {
  final String pdfPath;
  Pointer<Void>? _handle;

  PdfRendererLinux(this.pdfPath);

  Future<void> _ensureOpen() async {
    if (_handle == null) {
      final pathPtr = pdfPath.toNativeUtf8();
      _handle = openPdf(pathPtr);
      ffi.malloc.free(pathPtr);
      if (_handle == nullptr) {
        throw Exception('Failed to open PDF: $pdfPath');
      }
    }
  }

  Future<int> getPageCount() async {
    await _ensureOpen();
    return nativeGetPageCount(_handle!);
  }

  Future<Uint8List> renderPage(
    int pageIndex, {
    int width = 800,
    int height = 1000,
  }) async {
    await _ensureOpen();
    final int bufferSize = width * height * 4; // RGBA
    final buffer = ffi.malloc.allocate<Uint8>(bufferSize);
    final result = nativeRenderPage(_handle!, pageIndex, buffer, width, height);
    if (result != 1) {
      ffi.malloc.free(buffer);
      throw Exception('Failed to render page $pageIndex');
    }
    final bytes = Uint8List.fromList(buffer.asTypedList(bufferSize));
    ffi.malloc.free(buffer);
    return bytes;
  }

  void dispose() {
    if (_handle != null && _handle != nullptr) {
      closePdf(_handle!);
      _handle = null;
    }
  }
}
