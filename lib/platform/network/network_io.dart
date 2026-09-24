import 'dart:io';
import '../../domain/ports/network_port.dart';
NetworkPort createNetworkPort() => SocketNetworkPort();
class SocketNetworkPort implements NetworkPort {
  @override
  Future<bool> checkOnline() async {
    try {
      final socket = await Socket.connect('1.1.1.1', 443, timeout: const Duration(seconds: 2));
      await socket.close();
      return true;
    } catch (_) {
      return false;
    }
  }
}
