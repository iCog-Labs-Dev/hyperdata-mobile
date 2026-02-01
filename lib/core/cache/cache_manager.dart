import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static late Box _box;

  /// Initialize Hive Storage
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('cacheBox');
  }

  /// Save Data to Cache
  static Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  /// Get Cached Data
  static dynamic getData(String key) {
    return _box.get(key);
  }

  /// Remove Cached Data
  static Future<void> removeData(String key) async {
    await _box.delete(key);
  }

  /// Clear All Cached Data
  static Future<void> clearCache() async {
    await _box.clear();
  }
}
