import 'package:web/web.dart' as web;
import '../../domain/ports/theme_port.dart';
ThemePort createThemePort() => WebThemePort();
class WebThemePort implements ThemePort {
  @override
  bool get isDarkMode => web.window.matchMedia('(prefers-color-scheme: dark)').matches;
}
