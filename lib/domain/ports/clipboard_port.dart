abstract interface class ClipboardPort {
  Future<void> copy(String text);
}
