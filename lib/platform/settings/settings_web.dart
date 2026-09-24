import 'package:web/web.dart' as web;
import '../../domain/ports/settings_port.dart';
SettingsPort createSettingsPort() => SessionSettingsPort();
class SessionSettingsPort implements SettingsPort {
  @override
  Future<String?> get(String key) async => web.window.sessionStorage.getItem(key);
  @override
  Future<void> set(String key, String value) async => web.window.sessionStorage.setItem(key, value);
}
