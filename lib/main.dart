import 'package:flutter/material.dart';

import 'data/note_repository.dart';
import 'platform/clipboard/clipboard.dart';
import 'platform/env/env.dart';
import 'domain/ports/env_info.dart';
import 'platform/export/export.dart';
import 'platform/id/id.dart';
import 'platform/locale/locale.dart';
import 'platform/log/log.dart';
import 'platform/network/network.dart';
import 'platform/quota/quota.dart';
import 'platform/settings/settings.dart';
import 'platform/share/share.dart';
import 'platform/storage/storage.dart';
import 'platform/theme/theme.dart';
import 'platform/time/time.dart';
import 'platform/window/window.dart';
import 'presentation/notes_page.dart';
import 'presentation/ports_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = NoteRepository(createNoteStorage());
  final env = createEnvInfo();
  final ports = PortsBundle(
    clipboard: createClipboardPort(),
    exporter: createExportPort(),
    theme: createThemePort(),
    locale: createLocalePort(),
    network: createNetworkPort(),
    window: createWindowPort(),
    quota: createQuotaPort(),
    share: createSharePort(),
    time: createTimePort(),
    id: createIdPort(),
    log: createLogPort(),
    settings: createSettingsPort(),
  );

  runApp(DevBoardApp(repository: repository, env: env, ports: ports));
}

class DevBoardApp extends StatelessWidget {
  const DevBoardApp({required this.repository, required this.env, required this.ports, super.key});

  final NoteRepository repository;
  final EnvInfo env;
  final PortsBundle ports;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevBoard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: NotesPage(repository: repository, env: env, ports: ports),
    );
  }
}
