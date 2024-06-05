import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// https://developers.google.com/identity/blockstore/android
class SecureStorageAndroidPlatform {
  const SecureStorageAndroidPlatform();

  final _tag = 'SecureStorageAndroidPlatform';
  final _channel = const MethodChannel('plugin.krootl.com/blockstore/method');

  Future<bool> put({required String key, required String? value}) async {
    try {
      await _channel.invokeMethod('put', {'key': key, 'value': value});
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $_tag.put');
    }
    return false;
  }

  Future<String?> get(String key) async {
    try {
      final result = await _channel.invokeMethod('get', {'key': key});
      return result as String?;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $_tag.get');
    }
    return null;
  }

  Future<bool> delete(String key) async {
    try {
      await _channel.invokeMethod('delete', {'key': key});
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $_tag.delete');
    }
    return false;
  }
}
