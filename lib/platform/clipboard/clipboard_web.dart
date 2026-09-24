import 'dart:js_interop';
import 'package:web/web.dart' as web;
import '../../domain/ports/clipboard_port.dart';

ClipboardPort createClipboardPort() => WebClipboardPort();

class WebClipboardPort implements ClipboardPort {
  @override
  Future<void> copy(String text) async {
    await web.window.navigator.clipboard.writeText(text).toDart;
  }
}
