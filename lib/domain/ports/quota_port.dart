class StorageQuota {
  const StorageQuota({this.quotaBytes, this.freeBytes, this.note});

  final int? quotaBytes;
  final int? freeBytes;
  final String? note;
}

abstract interface class QuotaPort {
  Future<StorageQuota> estimate();
}
