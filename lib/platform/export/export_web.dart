import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/note.dart';
import '../../domain/ports/export_port.dart';

ExportPort createExportPort() => WebExportPort();

class WebExportPort implements ExportPort {
  @override
  Future<String> exportNotes(List<Note> notes) async {
    final json = const JsonEncoder.withIndent('  ').convert(
      notes.map((note) => note.toJson()).toList(),
    );
    final bytes = json.toJS;
    final parts = <web.BlobPart>[bytes].toJS;
    final blob = web.Blob(parts);
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = 'devboard_export.json';
    anchor.click();
    web.URL.revokeObjectURL(url);
    return 'Файл підготовлено для завантаження з браузера';
  }
}
