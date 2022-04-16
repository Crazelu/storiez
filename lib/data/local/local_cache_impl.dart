import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:throtty/data/local/local_cache.dart';
import 'package:throtty/data/local/secure_storage.dart';
import 'package:throtty/utils/logger.dart';

class LocalCacheImpl implements LocalCache {
  static const token = 'userToken';

  late SecureStorage _storage;
  late SharedPreferences _sharedPreferences;

  LocalCacheImpl({
    required SecureStorage storage,
    required SharedPreferences sharedPreferences,
  }) {
    _storage = storage;
    _sharedPreferences = sharedPreferences;
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _storage.delete(token);
    } catch (e) {
      AppLogger.log(e);
    }
  }

  @override
  Object? getFromLocalCache(String key) {
    try {
      return _sharedPreferences.get(key);
    } catch (e) {
      AppLogger.log(e);
      return null;
    }
  }

  @override
  Future<String> getToken() async {
    return (await _storage.read(token)) ?? "";
  }

  @override
  Future<void> removeFromLocalCache(String key) async {
    await _sharedPreferences.remove(key);
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: token, value: token);
    } catch (e) {
      AppLogger.log(e);
    }
  }

  @override
  Future<void> saveToLocalCache({required String key, required value}) async {
    AppLogger.log('Data being saved: key: $key, value: $value');

    if (value is String) {
      await _sharedPreferences.setString(key, value);
    }
    if (value is bool) {
      await _sharedPreferences.setBool(key, value);
    }
    if (value is int) {
      await _sharedPreferences.setInt(key, value);
    }
    if (value is double) {
      await _sharedPreferences.setDouble(key, value);
    }
    if (value is List<String>) {
      await _sharedPreferences.setStringList(key, value);
    }
    if (value is Map) {
      await _sharedPreferences.setString(key, json.encode(value));
    }
  }

  @override
  Future<void> clearCache() async {
    await _storage.delete(token);
  }
}
