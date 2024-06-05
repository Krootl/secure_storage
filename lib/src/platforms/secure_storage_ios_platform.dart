import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:secure_storage/src/attributes/ios_keychain_attributes.dart';
import 'package:secure_storage/src/platforms/secure_storage_platform.dart';

/// A class to manage the keychain storage on iOS.
class SecureStorageIOSPlatform extends SecureStoragePlatform {
  const SecureStorageIOSPlatform({
    required this.attributes,
  });

  final _tag = 'SecureStorageIOSPlatform';
  final _channel = const MethodChannel('plugin.krootl.com/keychain/method');

  final IOSKeychainAttributes attributes;

  @override
  Future<bool> put({required String key, required String? value}) async {
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

  @override
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

  @override
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
