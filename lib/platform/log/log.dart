export '../../domain/ports/log_port.dart';
export 'log_stub.dart'
    if (dart.library.io) 'log_io.dart'
    if (dart.library.js_interop) 'log_web.dart';
