import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs{
  static final UserPrefs _instance = UserPrefs._internal();
  SharedPreferences? _prefs;

  // Private constructor
  UserPrefs._internal();

  // Singleton instance getter
  static UserPrefs get instance => _instance;
  
  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    if (UserPrefs.instance.getString("lang") == null) {
      UserPrefs.instance.setString("lang", "id");
    }
  }

  /// Save a string
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get a string
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Save a boolean
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get a boolean
  bool getBool(String key) {
    return _prefs?.getBool(key) ?? false;
  }

  /// Remove a key
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all preferences
  Future<void> clear() async {
    await _prefs?.clear();
  }
}