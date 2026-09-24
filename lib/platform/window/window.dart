export '../../domain/ports/window_port.dart';
export 'window_stub.dart'
    if (dart.library.io) 'window_io.dart'
    if (dart.library.js_interop) 'window_web.dart';
