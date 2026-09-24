import '../note.dart';

abstract interface class ExportPort {
  Future<String> exportNotes(List<Note> notes);
}
