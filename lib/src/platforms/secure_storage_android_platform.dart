import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'secure_storage_platform.dart';

/// https://developers.google.com/identity/blockstore/android
class SecureStorageAndroidPlatform extends SecureStoragePlatform {
  const SecureStorageAndroidPlatform();

  final _tag = 'SecureStorageAndroidPlatform';
  final _channel = const MethodChannel('plugin.krootl.com/blockstore/method');

  @override
  Future<bool> put({required String key, required String? value}) async {
    try {
      await _channel.invokeMethod('put', {'key': key, 'value': value});
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $_tag.put');
    }
    return false;
  }

  @override
  Future<String?> get(String key) async {
    try {
      final result = await _channel.invokeMethod('get', {'key': key});
      return result as String?;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $_tag.get');
    }
    return null;
  }

  @override
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
