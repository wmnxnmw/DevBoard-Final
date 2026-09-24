import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/ports/settings_port.dart';
SettingsPort createSettingsPort() => IniSettingsPort();
class IniSettingsPort implements SettingsPort {
  Future<File> _file() async {
    final executable = File(Platform.resolvedExecutable);
    return File('${executable.parent.path}${Platform.pathSeparator}devboard_settings.ini');
  }
  Future<Map<String, String>> _read() async {
    final file = await _file();
    if (!await file.exists()) return {};
    final map = <String, String>{};
    for (final raw in await file.readAsLines()) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#') || !line.contains('=')) continue;
      final parts = line.split('=');
      map[parts.first.trim()] = parts.sublist(1).join('=').trim();
    }
    return map;
  }
  @override
  Future<String?> get(String key) async => (await _read())[key];
  @override
  Future<void> set(String key, String value) async {
    final map = await _read();
    map[key] = value;
    final file = await _file();
    final content = map.entries.map((e) => '${e.key}=${e.value}').join('\n');
    await file.writeAsString('$content\n', flush: true);
  }
}
