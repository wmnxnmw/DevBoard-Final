class WindowSize {
  const WindowSize({required this.width, required this.height});

  final double width;
  final double height;
}

abstract interface class WindowPort {
  WindowSize get size;
}
