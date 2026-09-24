export '../../domain/ports/locale_port.dart';
export 'locale_stub.dart'
    if (dart.library.io) 'locale_io.dart'
    if (dart.library.js_interop) 'locale_web.dart';
