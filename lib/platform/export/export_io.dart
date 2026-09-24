import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/note.dart';
import '../../domain/ports/export_port.dart';

ExportPort createExportPort() => FileExportPort();

class FileExportPort implements ExportPort {
  @override
  Future<String> exportNotes(List<Note> notes) async {
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(
      '${dir.path}${Platform.pathSeparator}devboard_export_$stamp.json',
    );
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(
        notes.map((note) => note.toJson()).toList(),
      ),
    );
    return 'Експортовано: ${file.path}';
  }
}
