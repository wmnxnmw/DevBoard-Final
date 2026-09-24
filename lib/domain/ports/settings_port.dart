abstract interface class SettingsPort {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
}
