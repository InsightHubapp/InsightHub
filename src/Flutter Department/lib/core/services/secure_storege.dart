import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps secure storage with app-specific recovery behavior.
@immutable
class SecureStorage {
  const SecureStorage._();

  static const AndroidOptions _androidOptions = AndroidOptions(
    resetOnError: true,
  );
  static const String _resetMessage = 'Data has been reset';
  static late final FlutterSecureStorage storage;

  static Future<FlutterSecureStorage> init() async =>
      storage = const FlutterSecureStorage(aOptions: _androidOptions);

  static Future<void> writeData({
    required String key,
    required String value,
  }) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> readData({required String key}) async {
    try {
      final token = await storage.read(key: key);
      if (token == _resetMessage) {
        return null;
      }

      return token;
    } catch (error, stackTrace) {
      log(
        'Failed to read secure storage key.',
        name: 'quicknotion.secure_storage',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  static Future<void> deleteData({required String key}) async {
    await storage.delete(key: key);
  }

  static Future<void> deleteAllData() async {
    await storage.deleteAll();
  }

  static Future<bool> checkData({required String key}) async {
    final token = await readData(key: key);
    return token != null;
  }
}