import 'dart:io';

import 'package:secure_storage/managers/secure_storage_android_platform.dart';
import 'package:secure_storage/managers/secure_storage_ios_platform.dart';

/// A class to manage the secure storage.
/// Keychain on iOS and BlockStore on Android.
/// https://developers.google.com/identity/blockstore/android
/// https://developer.apple.com/documentation/security/keychain_services
class SecureStorage {
  const SecureStorage._();

  factory SecureStorage() => instance;

  static const instance = SecureStorage._();

  /// Put value to secure storage
  /// [key] - The key to store the value.
  /// [value] - The value to store.
  /// Returns true if the value was successfully stored.
  /// Returns false if the value was not stored.
  /// Throws an [UnimplementedError] if the platform is not supported.
  Future<bool> put(String key, String value) async {
    if (Platform.isAndroid) {
      return SecureStorageAndroidPlatform.put(key: key, value: value);
    } else if (Platform.isIOS) {
      return SecureStorageIOSPlatform.put(key, value);
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
      return SecureStorageAndroidPlatform.get(key);
    } else if (Platform.isIOS) {
      return SecureStorageIOSPlatform.get(key);
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
      return SecureStorageAndroidPlatform.delete(key);
    } else if (Platform.isIOS) {
      return SecureStorageIOSPlatform.delete(key);
    }
    return throw UnimplementedError('Platform not supported');
  }
}
