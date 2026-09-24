import 'dart:convert';

import 'package:web/web.dart' as web;

import '../../domain/note.dart';
import '../../domain/ports/note_storage.dart';

NoteStorage createNoteStorage() => LocalStorageNoteStorage();

const _key = 'devboard_notes';

class LocalStorageNoteStorage implements NoteStorage {
  @override
  Future<List<Note>> readAll() async {
    final raw = web.window.localStorage.getItem(_key);
    if (raw == null || raw.trim().isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => Note.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> writeAll(List<Note> notes) async {
    web.window.localStorage.setItem(
      _key,
      jsonEncode(notes.map((note) => note.toJson()).toList()),
    );
  }
}
