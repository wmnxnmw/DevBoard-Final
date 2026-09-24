export '../../domain/ports/env_info.dart';
export 'env_stub.dart'
    if (dart.library.io) 'env_io.dart'
    if (dart.library.js_interop) 'env_web.dart';
