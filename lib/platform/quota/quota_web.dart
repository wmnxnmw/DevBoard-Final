import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/ports/quota_port.dart';

QuotaPort createQuotaPort() => WebQuotaPort();

class WebQuotaPort implements QuotaPort {
  @override
  Future<StorageQuota> estimate() async {
    try {
      final result =
          await web.window.navigator.storage.estimate().toDart;
      final quota = result.quota;
      final usage = result.usage;
      return StorageQuota(
        quotaBytes: quota,
        freeBytes: quota - usage,
        note: 'Оцінка квоти сховища браузера',
      );
    } catch (_) {
      return const StorageQuota(
        note: 'StorageManager.estimate недоступний',
      );
    }
  }
}