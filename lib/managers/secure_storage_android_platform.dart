import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// https://developers.google.com/identity/blockstore/android
mixin SecureStorageAndroidPlatform {
  static String get tag => 'SecureStorageAndroidPlatform';

  static MethodChannel get channel => const MethodChannel('plugin.krootl.com/blockstore/method');

  static Future<bool> put({required String key, required String? value}) async {
    try {
      await channel.invokeMethod('put', {'key': key, 'value': value});
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $tag.put');
    }
    return false;
  }

  static Future<String?> get(String key) async {
    try {
      final result = await channel.invokeMethod('get', {'key': key});
      return result as String?;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $tag.get');
    }
    return null;
  }

  static Future<bool> delete(String key) async {
    try {
      await channel.invokeMethod('delete', {'key': key});
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, Trace: $trace, From: $tag.delete');
    }
    return false;
  }
}
