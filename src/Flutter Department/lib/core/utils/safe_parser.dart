class SafeParser {
  static dynamic _getValue(Map<String, dynamic>? data, String key) {
    if (data == null) return null;

    dynamic value = data[key];

    if (value == null && key.isNotEmpty) {
      final pascalKey = key[0].toUpperCase() + key.substring(1);
      value = data[pascalKey];
    }

    return value;
  }

  static T _safe<T>(T Function() fn, T defaultValue) {
    try {
      return fn();
    } catch (_) {
      return defaultValue;
    }
  }

  static num? _toNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  static String getString(
    Map<String, dynamic>? data,
    String key, {
    String defaultValue = 'unknown',
  }) {
    return _safe(() {
      final value = _getValue(data, key);
      if (value == null) return defaultValue;
      return value.toString();
    }, defaultValue);
  }

  static double getDouble(
    Map<String, dynamic>? data,
    String key, {
    double defaultValue = 0.0,
  }) {
    return _safe(() {
      final value = _getValue(data, key);
      if (value == null) return defaultValue;

      final n = _toNum(value);
      return n?.toDouble() ?? defaultValue;
    }, defaultValue);
  }

  static int getInt(
    Map<String, dynamic>? data,
    String key, {
    int defaultValue = 0,
  }) {
    return _safe(() {
      final value = _getValue(data, key);
      if (value == null) return defaultValue;

      final n = _toNum(value);
      return n?.toInt() ?? defaultValue;
    }, defaultValue);
  }

  static List<dynamic> getList(
    Map<String, dynamic>? data,
    String key, {
    List<dynamic> defaultValue = const [],
  }) {
    return _safe(() {
      final value = _getValue(data, key);
      if (value is List) return value;
      return defaultValue;
    }, defaultValue);
  }

  static Map<String, dynamic> getMap(
    Map<String, dynamic>? data,
    String key, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    return _safe(() {
      final value = _getValue(data, key);
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
      return defaultValue;
    }, defaultValue);
  }

  static bool getBool(
    Map<String, dynamic>? data,
    String key, {
    bool defaultValue = false,
  }) {
    return _safe(() {
      final value = _getValue(data, key);
      if (value == null) return defaultValue;

      if (value is bool) return value;

      if (value is String) {
        final lower = value.toLowerCase().trim();
        return lower == 'true' ||
            lower == '1' ||
            lower == 'yes' ||
            lower == 'on';
      }

      if (value is int) return value == 1;

      return defaultValue;
    }, defaultValue);
  }
}