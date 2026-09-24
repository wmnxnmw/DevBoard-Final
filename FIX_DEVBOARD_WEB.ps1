$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path
$required = @(
    'pubspec.yaml',
    'lib\platform\clipboard\clipboard_web.dart',
    'lib\platform\log\log_web.dart',
    'lib\platform\quota\quota_web.dart',
    'lib\platform\share\share_web.dart',
    'lib\platform\time\time_web.dart'
)

foreach ($relative in $required) {
    $full = Join-Path $root $relative
    if (-not (Test-Path $full)) {
        throw "Не знайдено файл: $relative. Запусти цей скрипт з кореня проєкту DevBoard, де лежить pubspec.yaml."
    }
}

$backupDir = Join-Path $root '.backup-before-web-fix'
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

function Backup-And-Write([string]$relative, [string]$content) {
    $full = Join-Path $root $relative
    $backup = Join-Path $backupDir $relative
    $backupParent = Split-Path $backup -Parent
    New-Item -ItemType Directory -Force -Path $backupParent | Out-Null
    Copy-Item -Force $full $backup
    Set-Content -Path $full -Value $content -Encoding UTF8
}

$pubspec = Get-Content (Join-Path $root 'pubspec.yaml') -Raw
$pubspec = $pubspec -replace 'web:\s*\^1\.1\.0', 'web: ^1.1.1'
Backup-And-Write 'pubspec.yaml' $pubspec

Backup-And-Write 'lib\platform\clipboard\clipboard_web.dart' @'
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/ports/clipboard_port.dart';

ClipboardPort createClipboardPort() => WebClipboardPort();

class WebClipboardPort implements ClipboardPort {
  @override
  Future<void> copy(String text) async {
    await web.window.navigator.clipboard.writeText(text).toDart;
  }
}
'@

Backup-And-Write 'lib\platform\log\log_web.dart' @'
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/ports/log_port.dart';

LogPort createLogPort() => WebLogPort();

class WebLogPort implements LogPort {
  @override
  Future<void> log(String message) async {
    web.console.info('[DevBoard] $message');

    try {
      final request = web.window.indexedDB.open('devboard_logs', 1);

      request.onupgradeneeded = ((web.Event event) {
        final db = request.result as web.IDBDatabase;
        if (!db.objectStoreNames.contains('logs')) {
          db.createObjectStore(
            'logs',
            web.IDBObjectStoreParameters(autoIncrement: true),
          );
        }
      }).toJS;

      request.onsuccess = ((web.Event event) {
        final db = request.result as web.IDBDatabase;
        final transaction = db.transaction('logs'.toJS, 'readwrite');
        transaction.objectStore('logs').add(
          '[${DateTime.now().toIso8601String()}] $message'.toJS,
        );
      }).toJS;
    } catch (_) {
      // Console logging remains available if IndexedDB is blocked.
    }
  }
}
'@

Backup-And-Write 'lib\platform\quota\quota_web.dart' @'
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
      final quota = result.quota.toDartInt;
      final usage = result.usage.toDartInt;
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
'@

Backup-And-Write 'lib\platform\share\share_web.dart' @'
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/note.dart';
import '../../domain/ports/share_port.dart';

SharePort createSharePort() => WebSharePort();

class WebSharePort implements SharePort {
  @override
  Future<String> share(Note note) async {
    try {
      final data = web.ShareData(
        title: 'DevBoard',
        text: '${note.text}\n${note.createdAt}',
      );
      await web.window.navigator.share(data).toDart;
      return 'Нотатку передано через Web Share API';
    } catch (_) {
      return 'Web Share API недоступний у цьому браузері';
    }
  }
}
'@

Backup-And-Write 'lib\platform\time\time_web.dart' @'
import 'dart:js_interop';

import '../../domain/ports/time_port.dart';

TimePort createTimePort() => WebTimePort();

class WebTimePort implements TimePort {
  @override
  String get timeZoneName {
    final intl = globalContext.getProperty<JSObject>('Intl'.toJS);
    final dateTimeFormat =
        intl.getProperty<JSFunction>('DateTimeFormat'.toJS);
    final formatter = dateTimeFormat.callAsConstructor<JSObject>();
    final options = formatter.callMethod<JSObject>('resolvedOptions'.toJS);
    return options.getProperty<JSString>('timeZone'.toJS).toDart;
  }
}
'@

Write-Host ''
Write-Host 'Web-адаптери DevBoard виправлено.' -ForegroundColor Green
Write-Host "Резервні копії: $backupDir"
Write-Host ''
Write-Host 'Тепер виконай:' -ForegroundColor Cyan
Write-Host '  flutter clean'
Write-Host '  flutter pub get'
Write-Host '  flutter run -d chrome'
