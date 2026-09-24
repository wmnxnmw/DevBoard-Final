import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/ports/quota_port.dart';
QuotaPort createQuotaPort() => WindowsQuotaPort();
class WindowsQuotaPort implements QuotaPort {
  @override
  Future<StorageQuota> estimate() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final drive = dir.path.substring(0, 1);
      final result = await Process.run(
        'powershell',
        [
          '-NoProfile',
          '-Command',
          "[System.IO.DriveInfo]::new('${drive}:').AvailableFreeSpace",
        ],
      );
      final free = int.tryParse(result.stdout.toString().trim());
      return StorageQuota(freeBytes: free, note: 'Вільне місце системного диска');
    } catch (_) {
      return const StorageQuota(note: 'Не вдалося визначити вільне місце диска');
    }
  }
}
