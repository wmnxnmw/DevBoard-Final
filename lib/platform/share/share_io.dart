import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../domain/note.dart';
import '../../domain/ports/share_port.dart';
SharePort createSharePort() => MailtoSharePort();
class MailtoSharePort implements SharePort {
  @override
  Future<String> share(Note note) async {
    final subject = Uri.encodeComponent('DevBoard: ${note.text}');
    final body = Uri.encodeComponent('${note.text}\n\n${note.createdAt}');
    final uri = 'mailto:?subject=$subject&body=$body';
    await Process.run('cmd', ['/c', 'start', '', uri]);
    debugPrint('Opened mailto: $uri');
    return 'Відкрито поштовий клієнт через mailto';
  }
}
