import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A class to manage the keychain storage on iOS.
mixin SecureStorageIOSPlatform {
  static String get tag => 'SecureStorageIOSPlatform';

  static MethodChannel get channel => const MethodChannel('plugin.krootl.com/keychain/method');

  /// Keys
  /// The identifier for the keychain account.
  /// Provide a unique string to identify the values which are stored in the keychain.
  static const _kAccount = 'plugin.krootl.com/keychain';

  static Future<bool> put(String key, String? value) async {
    try {
      await channel.invokeMethod('put', {
        'account': _kAccount,
        'service': key,
        'data': value,
      });
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, \nTrace: $trace, \nFrom: $tag.put');
    }
    return false;
  }

  static Future<String?> get(String key) async {
    try {
      final result = await channel.invokeMethod('get', {
        'account': _kAccount,
        'service': key,
      });
      return result as String?;
    } catch (e, trace) {
      debugPrint('Error: $e, \nTrace: $trace, \nFrom: $tag.get');
    }
    return null;
  }

  static Future<bool> delete(String key) async {
    try {
      await channel.invokeMethod('delete', {
        'account': _kAccount,
        'service': key,
      });
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, \nTrace: $trace, \nFrom: $tag.delete');
    }
    return false;
  }
}
