export '../../domain/ports/share_port.dart';
export 'share_stub.dart'
    if (dart.library.io) 'share_io.dart'
    if (dart.library.js_interop) 'share_web.dart';
