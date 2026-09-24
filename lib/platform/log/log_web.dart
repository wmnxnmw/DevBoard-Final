import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/ports/log_port.dart';

LogPort createLogPort() => WebLogPort();

class WebLogPort implements LogPort {
  @override
  Future<void> log(String message) async {
    web.console.info('[DevBoard] $message'.toJS);

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