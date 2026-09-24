export '../../domain/ports/time_port.dart';
export 'time_stub.dart'
    if (dart.library.io) 'time_io.dart'
    if (dart.library.js_interop) 'time_web.dart';
