export '../../domain/ports/settings_port.dart';
export 'settings_stub.dart'
    if (dart.library.io) 'settings_io.dart'
    if (dart.library.js_interop) 'settings_web.dart';
