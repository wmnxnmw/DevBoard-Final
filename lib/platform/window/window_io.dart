import 'dart:ui';
import '../../domain/ports/window_port.dart';
WindowPort createWindowPort() => FlutterWindowPort();
class FlutterWindowPort implements WindowPort {
  @override
  WindowSize get size {
    final view = PlatformDispatcher.instance.views.first;
    final logical = view.physicalSize / view.devicePixelRatio;
    return WindowSize(width: logical.width, height: logical.height);
  }
}
