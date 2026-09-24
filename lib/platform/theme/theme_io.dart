import 'dart:ui';
import '../../domain/ports/theme_port.dart';
ThemePort createThemePort() => WindowsThemePort();
class WindowsThemePort implements ThemePort {
  @override
  bool get isDarkMode => PlatformDispatcher.instance.platformBrightness == Brightness.dark;
}
