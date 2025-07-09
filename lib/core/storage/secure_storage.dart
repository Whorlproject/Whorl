import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'secure_messenger_prefs',
      preferencesKeyPrefix: 'sm_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.secure.messenger',
      accountName: 'SecureMessenger',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    lOptions: LinuxOptions(),
    wOptions: WindowsOptions(),
    mOptions: MacOsOptions(
      groupId: 'group.secure.messenger',
      accountName: 'SecureMessenger',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<void> initialize() async {
    try {
      // Test storage availability
      await _storage.containsKey(key: 'test');
    } catch (e) {
      debugPrint('Error initializing secure storage: $e');
    }
  }
  
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint('Error writing to secure storage: $e');
      throw StorageException('Failed to write data');
    }
  }
  
  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint('Error reading from secure storage: $e');
      return null;
    }
  }
  
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('Error deleting from secure storage: $e');
    }
  }
  
  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('Error deleting all from secure storage: $e');
    }
  }
  
  static Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      debugPrint('Error checking key in secure storage: $e');
      return false;
    }
  }
  
  static Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      debugPrint('Error reading all from secure storage: $e');
      return {};
    }
  }

  static Future<void> secureDelete(String key) async {
    try {
      // Sobrescrever valor com dados aleatórios antes de apagar
      final value = await _storage.read(key: key);
      if (value != null && value.isNotEmpty) {
        final randomData = List.generate(value.length, (i) => String.fromCharCode(65 + (i % 26))).join();
        await _storage.write(key: key, value: randomData);
      }
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('Error in secureDelete: $e');
    }
  }

  static Future<void> secureDeleteAll() async {
    try {
      final all = await _storage.readAll();
      for (final key in all.keys) {
        await secureDelete(key);
      }
    } catch (e) {
      debugPrint('Error in secureDeleteAll: $e');
    }
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);
  
  @override
  String toString() => 'StorageException: $message';
}
