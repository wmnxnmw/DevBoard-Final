export '../../domain/ports/note_storage.dart';
export 'storage_stub.dart'
    if (dart.library.io) 'storage_io.dart'
    if (dart.library.js_interop) 'storage_web.dart';
