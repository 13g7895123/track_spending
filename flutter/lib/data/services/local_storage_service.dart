import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/app_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // User preferences
  Future<void> saveUserToken(String token) async {
    await _prefs.setString(AppConstants.userTokenKey, token);
  }

  String? getUserToken() {
    return _prefs.getString(AppConstants.userTokenKey);
  }

  Future<void> removeUserToken() async {
    await _prefs.remove(AppConstants.userTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.userIdKey, userId);
  }

  String? getUserId() {
    return _prefs.getString(AppConstants.userIdKey);
  }

  Future<void> removeUserId() async {
    await _prefs.remove(AppConstants.userIdKey);
  }

  // Theme preferences
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(AppConstants.themeKey, themeMode);
  }

  String? getThemeMode() {
    return _prefs.getString(AppConstants.themeKey);
  }

  // Language preferences
  Future<void> saveLanguage(String language) async {
    await _prefs.setString(AppConstants.languageKey, language);
  }

  String? getLanguage() {
    return _prefs.getString(AppConstants.languageKey);
  }

  // First time user
  Future<void> setFirstTime(bool isFirstTime) async {
    await _prefs.setBool(AppConstants.firstTimeKey, isFirstTime);
  }

  bool isFirstTime() {
    return _prefs.getBool(AppConstants.firstTimeKey) ?? true;
  }

  // Generic methods for saving/loading objects
  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    final jsonString = json.encode(object);
    await _prefs.setString(key, jsonString);
  }

  Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveObjectList(String key, List<Map<String, dynamic>> objects) async {
    final jsonString = json.encode(objects);
    await _prefs.setString(key, jsonString);
  }

  List<Map<String, dynamic>>? getObjectList(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    }
    return null;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Remove specific key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}