import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/note.dart';
import '../../domain/ports/note_storage.dart';

NoteStorage createNoteStorage() => FileNoteStorage();

class FileNoteStorage implements NoteStorage {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}devboard_notes.json');
  }

  @override
  Future<List<Note>> readAll() async {
    final file = await _file();
    if (!await file.exists()) return [];

    final raw = await file.readAsString();
    if (raw.trim().isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => Note.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> writeAll(List<Note> notes) async {
    final file = await _file();
    await file.writeAsString(
      jsonEncode(notes.map((note) => note.toJson()).toList()),
    );
  }
}
