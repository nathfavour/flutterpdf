import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi;

// This assumes you have a native library called 'libnativepdf.so' in your linux build output.
final DynamicLibrary _nativePdfLib =
    Platform.isLinux
        ? DynamicLibrary.open('libnativepdf.so')
        : throw UnsupportedError('Native PDF only supported on Linux');

// C: void* open_pdf(const char* path);
typedef _OpenPdfNative = Pointer<Void> Function(Pointer<ffi.Utf8>);
typedef _OpenPdfDart = Pointer<Void> Function(Pointer<ffi.Utf8>);
final _OpenPdfDart openPdf =
    _nativePdfLib
        .lookup<NativeFunction<_OpenPdfNative>>('open_pdf')
        .asFunction();

// C: int get_page_count(void* handle);
typedef _GetPageCountNative = Int32 Function(Pointer<Void>);
typedef _GetPageCountDart = int Function(Pointer<Void>);
final _GetPageCountDart getPageCount =
    _nativePdfLib
        .lookup<NativeFunction<_GetPageCountNative>>('get_page_count')
        .asFunction();

// C: int render_page(void* handle, int page, void* buffer, int width, int height);
typedef _RenderPageNative =
    Int32 Function(Pointer<Void>, Int32, Pointer<Uint8>, Int32, Int32);
typedef _RenderPageDart =
    int Function(Pointer<Void>, int, Pointer<Uint8>, int, int);
final _RenderPageDart renderPage =
    _nativePdfLib
        .lookup<NativeFunction<_RenderPageNative>>('render_page')
        .asFunction();

// Add more FFI bindings as needed for your native library.
