import 'dart:js_interop';
import 'dart:js_interop_unsafe';

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