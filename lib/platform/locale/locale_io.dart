import 'dart:io';
import '../../domain/ports/locale_port.dart';
LocalePort createLocalePort() => WindowsLocalePort();
class WindowsLocalePort implements LocalePort {
  @override
  String get localeName => Platform.localeName;
}
