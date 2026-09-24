export '../../domain/ports/id_port.dart';
export 'id_stub.dart'
    if (dart.library.io) 'id_io.dart'
    if (dart.library.js_interop) 'id_web.dart';
