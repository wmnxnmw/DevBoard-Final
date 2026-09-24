import 'dart:io';
import '../../domain/ports/id_port.dart';
IdPort createIdPort() => HostnameIdPort();
class HostnameIdPort implements IdPort {
  @override
  Future<String> getDeviceId() async => Platform.localHostname;
}
