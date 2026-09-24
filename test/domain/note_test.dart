import 'package:flutter_test/flutter_test.dart';
import 'package:devboard/domain/note.dart';

void main() {
  test('Note serializes and deserializes without data loss', () {
    final source = Note(
      id: '1',
      text: 'Hello',
      createdAt: DateTime.parse('2026-09-24T12:00:00.000Z'),
    );

    final restored = Note.fromJson(source.toJson());

    expect(restored.id, source.id);
    expect(restored.text, source.text);
    expect(restored.createdAt, source.createdAt);
  });
}
