import 'dart:io';

import 'package:secure_storage/src/attributes/ios_keychain_attributes.dart';
import 'package:secure_storage/src/platforms/secure_storage_android_platform.dart';
import 'package:secure_storage/src/platforms/secure_storage_ios_platform.dart';

/// A class to manage the secure storage.
/// Keychain on iOS and BlockStore on Android.
/// https://developers.google.com/identity/blockstore/android
/// https://developer.apple.com/documentation/security/keychain_services
class SecureStorage {
  SecureStorage({
    IOSKeychainAttributes iosAttributes = const IOSKeychainAttributes(),
  })  : _androidPlatform = const SecureStorageAndroidPlatform(),
        _iosPlatform = SecureStorageIOSPlatform(attributes: iosAttributes);

  final SecureStorageAndroidPlatform _androidPlatform;
  final SecureStorageIOSPlatform _iosPlatform;

  /// Put value to secure storage
  /// [key] - The key to store the value.
  /// [value] - The value to store.
  /// Returns true if the value was successfully stored.
  /// Returns false if the value was not stored.
  /// Throws an [UnimplementedError] if the platform is not supported.
  Future<bool> put(String key, String value) async {
    if (Platform.isAndroid) {
      return _androidPlatform.put(key: key, value: value);
    } else if (Platform.isIOS) {
      return _iosPlatform.put(key, value);
    }
    return throw UnimplementedError('Platform not supported');
  }

  /// Get value from secure storage
  /// [key] - The key to get the value.
  /// Returns the value if the value was successfully retrieved.
  /// Returns null if the value was not retrieved.
  /// Throws an [UnimplementedError] if the platform is not supported.
  Future<String?> get(String key) async {
    if (Platform.isAndroid) {
      return _androidPlatform.get(key);
    } else if (Platform.isIOS) {
      return _iosPlatform.get(key);
    }
    return throw UnimplementedError('Platform not supported');
  }

  /// Delete value from secure storage
  /// [key] - The key to delete the value.
  /// Returns true if the value was successfully deleted.
  /// Returns false if the value was not deleted.
  /// Throws an [UnimplementedError] if the platform is not supported.
  Future<bool?> delete(String key) async {
    if (Platform.isAndroid) {
      return _androidPlatform.delete(key);
    } else if (Platform.isIOS) {
      return _iosPlatform.delete(key);
    }
    return throw UnimplementedError('Platform not supported');
  }
}
