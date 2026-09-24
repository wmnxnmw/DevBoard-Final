import 'dart:js_interop';
import 'package:web/web.dart' as web;
import '../../domain/note.dart';
import '../../domain/ports/share_port.dart';
SharePort createSharePort() => WebSharePort();
class WebSharePort implements SharePort {
  @override
  Future<String> share(Note note) async {
    try {
      final data = web.ShareData(
        title: 'DevBoard',
        text: '${note.text}\n${note.createdAt}',
      );
      await web.window.navigator.share(data).toDart;
      return 'Нотатку передано через Web Share API';
    } catch (_) {
      return 'Web Share API недоступний у цьому браузері';
    }
  }
}
