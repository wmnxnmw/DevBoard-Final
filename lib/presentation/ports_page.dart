import 'package:flutter/material.dart';

import '../data/note_repository.dart';
import '../domain/note.dart';
import '../domain/ports/clipboard_port.dart';
import '../domain/ports/export_port.dart';
import '../domain/ports/theme_port.dart';
import '../domain/ports/locale_port.dart';
import '../domain/ports/network_port.dart';
import '../domain/ports/window_port.dart';
import '../domain/ports/quota_port.dart';
import '../domain/ports/share_port.dart';
import '../domain/ports/time_port.dart';
import '../domain/ports/id_port.dart';
import '../domain/ports/log_port.dart';
import '../domain/ports/settings_port.dart';
import 'widgets/section_card.dart';

class PortsBundle {
  const PortsBundle({
    required this.clipboard,
    required this.exporter,
    required this.theme,
    required this.locale,
    required this.network,
    required this.window,
    required this.quota,
    required this.share,
    required this.time,
    required this.id,
    required this.log,
    required this.settings,
  });

  final ClipboardPort clipboard;
  final ExportPort exporter;
  final ThemePort theme;
  final LocalePort locale;
  final NetworkPort network;
  final WindowPort window;
  final QuotaPort quota;
  final SharePort share;
  final TimePort time;
  final IdPort id;
  final LogPort log;
  final SettingsPort settings;
}

class PortsPage extends StatefulWidget {
  const PortsPage({required this.repository, required this.ports, super.key});

  final NoteRepository repository;
  final PortsBundle ports;

  @override
  State<PortsPage> createState() => _PortsPageState();
}

class _PortsPageState extends State<PortsPage> {
  final Map<String, String> _result = {};
  bool _busy = false;

  Future<void> _run(String key, Future<String> Function() action) async {
    setState(() => _busy = true);
    try {
      final result = await action();
      if (!mounted) return;
      setState(() {
        _result[key] = result;
        _busy = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _result[key] = 'Помилка: $error';
        _busy = false;
      });
    }
  }

  Future<Note> _firstOrSample() async {
    final notes = await widget.repository.getAll();
    if (notes.isNotEmpty) return notes.first;
    return Note(id: 'sample', text: 'Демонстраційна нотатка DevBoard', createdAt: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Платформні порти')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Індивідуальна частина', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('У проєкті підготовлено всі 12 варіантів із методички. На захисті можна продемонструвати потрібний за номером у списку.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              _portCard('1. ClipboardPort', 'Windows: Flutter Clipboard, Web: navigator.clipboard', () async {
                await widget.ports.clipboard.copy('DevBoard ClipboardPort: тестове повідомлення');
                return 'Текст скопійовано у буфер обміну';
              }, 'clipboard'),
              _portCard('2. ExportPort', 'Windows: файл на диску, Web: Blob + download', () async {
                return widget.ports.exporter.exportNotes(await widget.repository.getAll());
              }, 'export'),
              _portCard('3. ThemePort', 'Windows: PlatformDispatcher, Web: prefers-color-scheme', () async {
                return widget.ports.theme.isDarkMode ? 'Темна системна тема' : 'Світла системна тема';
              }, 'theme'),
              _portCard('4. LocalePort', 'Windows: системна локаль ОС, Web: navigator.language', () async {
                return widget.ports.locale.localeName;
              }, 'locale'),
              _portCard('5. NetworkPort', 'Windows: Socket.connect, Web: navigator.onLine', () async {
                return (await widget.ports.network.checkOnline()) ? 'Мережа доступна' : 'Мережа недоступна';
              }, 'network'),
              _portCard('6. WindowPort', 'Windows: розмір Flutter desktop view, Web: innerWidth / innerHeight', () async {
                final size = widget.ports.window.size;
                return '${size.width.toStringAsFixed(0)} x ${size.height.toStringAsFixed(0)} logical px';
              }, 'window'),
              _portCard('7. QuotaPort', 'Windows: вільне місце диска, Web: navigator.storage.estimate()', () async {
                final q = await widget.ports.quota.estimate();
                if (q.freeBytes != null) return '${_bytes(q.freeBytes!)} доступно. ${q.note ?? ''}'.trim();
                if (q.quotaBytes != null) return 'Квота: ${_bytes(q.quotaBytes!)}. ${q.note ?? ''}'.trim();
                return q.note ?? 'Дані про квоту недоступні';
              }, 'quota'),
              _portCard('8. SharePort', 'Windows: mailto, Web: navigator.share', () async {
                return widget.ports.share.share(await _firstOrSample());
              }, 'share'),
              _portCard('9. TimePort', 'Windows: DateTime.now().timeZoneName, Web: Intl.DateTimeFormat', () async {
                return widget.ports.time.timeZoneName;
              }, 'time'),
              _portCard('10. IdPort', 'Windows: імʼя машини, Web: crypto.randomUUID + localStorage', () async {
                return await widget.ports.id.getDeviceId();
              }, 'id'),
              _portCard('11. LogPort', 'Windows: devboard.log, Web: console + IndexedDB', () async {
                await widget.ports.log.log('Демонстрація LogPort з DevBoard');
                return 'Подію записано';
              }, 'log'),
              _portCard('12. SettingsPort', 'Windows: INI поруч із exe, Web: sessionStorage', () async {
                final key = 'demo_theme';
                await widget.ports.settings.set(key, 'default');
                return 'Значення $key = ${await widget.ports.settings.get(key)}';
              }, 'settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _portCard(String title, String description, Future<String> Function() action, String key) {
    return SectionCard(
      title: title,
      subtitle: description,
      child: Row(
        children: [
          Expanded(child: Text(_result[key] ?? 'Не перевірено')),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: _busy ? null : () => _run(key, action),
            child: const Text('Перевірити'),
          ),
        ],
      ),
    );
  }

  String _bytes(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    if (bytes >= 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '$bytes B';
  }
}
