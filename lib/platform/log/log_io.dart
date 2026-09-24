import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/ports/log_port.dart';
LogPort createLogPort() => FileLogPort();
class FileLogPort implements LogPort {
  @override
  Future<void> log(String message) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}${Platform.pathSeparator}devboard.log');
    final line = '[${DateTime.now().toIso8601String()}] $message\n';
    await file.writeAsString(line, mode: FileMode.append, flush: true);
  }
}
