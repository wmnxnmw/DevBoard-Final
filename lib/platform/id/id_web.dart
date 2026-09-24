import 'package:web/web.dart' as web;
import '../../domain/ports/id_port.dart';
IdPort createIdPort() => BrowserIdPort();
const _key = 'devboard_device_id';
class BrowserIdPort implements IdPort {
  @override
  Future<String> getDeviceId() async {
    final storage = web.window.localStorage;
    final current = storage.getItem(_key);
    if (current != null && current.isNotEmpty) return current;
    final id = web.window.crypto.randomUUID();
    storage.setItem(_key, id);
    return id;
  }
}
