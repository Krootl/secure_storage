

abstract class SecureStoragePlatform {
  const SecureStoragePlatform();

  Future<bool> put({required String key, required String? value});

  Future<String?> get(String key);

  Future<void> delete(String key);
}
