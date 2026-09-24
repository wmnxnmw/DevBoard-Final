import 'package:flutter/services.dart';
import '../../domain/ports/clipboard_port.dart';

ClipboardPort createClipboardPort() => WindowsClipboardPort();

class WindowsClipboardPort implements ClipboardPort {
  @override
  Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
