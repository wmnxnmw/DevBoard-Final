import '../note.dart';

abstract interface class SharePort {
  Future<String> share(Note note);
}
