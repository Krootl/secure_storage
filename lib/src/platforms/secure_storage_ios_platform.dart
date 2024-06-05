import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:secure_storage/src/attributes/ios_keychain_attributes.dart';

/// A class to manage the keychain storage on iOS.
class SecureStorageIOSPlatform {
  const SecureStorageIOSPlatform({
    required this.attributes,
  });

  final _tag = 'SecureStorageIOSPlatform';
  final _channel = const MethodChannel('plugin.krootl.com/keychain/method');

  final IOSKeychainAttributes attributes;

  Future<bool> put(String key, String? value) async {
    try {
      await _channel.invokeMethod('put', {
        'account': attributes.account,
        'service': key,
        'data': value,
      });
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, \nTrace: $trace, \nFrom: $_tag.put');
    }
    return false;
  }

  Future<String?> get(String key) async {
    try {
      final result = await _channel.invokeMethod('get', {
        'account': attributes.account,
        'service': key,
      });
      return result as String?;
    } catch (e, trace) {
      debugPrint('Error: $e, \nTrace: $trace, \nFrom: $_tag.get');
    }
    return null;
  }

  Future<bool> delete(String key) async {
    try {
      await _channel.invokeMethod('delete', {
        'account': attributes.account,
        'service': key,
      });
      return true;
    } catch (e, trace) {
      debugPrint('Error: $e, \nTrace: $trace, \nFrom: $_tag.delete');
    }
    return false;
  }
}
