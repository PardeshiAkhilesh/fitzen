import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();
  
  // Secure Storage for Tokens
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'access_token');
  }

  // Shared Preferences for local flags
  Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', value);
  }

  Future<bool> getHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_seen_onboarding') ?? false;
  }
}
