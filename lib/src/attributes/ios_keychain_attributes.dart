class IOSKeychainAttributes {
  const IOSKeychainAttributes({
    this.account = 'plugin.krootl.com/keychain',
  });

  /// Keys
  /// The identifier for the keychain account.
  /// Provide a unique string to identify the values which are stored in the keychain.
  final String account;
}
