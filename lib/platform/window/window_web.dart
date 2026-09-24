import 'package:web/web.dart' as web;
import '../../domain/ports/window_port.dart';
WindowPort createWindowPort() => WebWindowPort();
class WebWindowPort implements WindowPort {
  @override
  WindowSize get size => WindowSize(
    width: web.window.innerWidth.toDouble(),
    height: web.window.innerHeight.toDouble(),
  );
}
