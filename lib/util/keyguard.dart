import 'package:flutter/services.dart';

const _methodChannel = MethodChannel('ru.leadpogrommer.fuck');

Future<bool> dismissKeyguard() async {
  return await _methodChannel.invokeMethod('dismiss');
}

Future<bool> isKeyguardLocked() async {
  return await _methodChannel.invokeMethod('isLocked');
}