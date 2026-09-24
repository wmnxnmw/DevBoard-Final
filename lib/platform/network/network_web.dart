import 'package:web/web.dart' as web;
import '../../domain/ports/network_port.dart';
NetworkPort createNetworkPort() => WebNetworkPort();
class WebNetworkPort implements NetworkPort {
  @override
  Future<bool> checkOnline() async => web.window.navigator.onLine;
}
