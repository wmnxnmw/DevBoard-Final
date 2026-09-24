export '../../domain/ports/network_port.dart';
export 'network_stub.dart'
    if (dart.library.io) 'network_io.dart'
    if (dart.library.js_interop) 'network_web.dart';
