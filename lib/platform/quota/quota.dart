export '../../domain/ports/quota_port.dart';
export 'quota_stub.dart'
    if (dart.library.io) 'quota_io.dart'
    if (dart.library.js_interop) 'quota_web.dart';
