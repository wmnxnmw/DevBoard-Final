import 'dart:io';
import '../../domain/ports/time_port.dart';
TimePort createTimePort() => WindowsTimePort();
class WindowsTimePort implements TimePort {
  @override
  String get timeZoneName => DateTime.now().timeZoneName;
}
