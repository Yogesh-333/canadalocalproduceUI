// lib/services/auth_service.dart
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Static credentials for now
  static const String _adminUsername = 'admin';
  static const String _adminPassword = 'Test@123';

  // Key for storing login state
  static const String _loginStateKey = 'admin_logged_in';

  // Login method
  Future<bool> login(String username, String password) async {
    // Check credentials
    if (username == _adminUsername && password == _adminPassword) {
      try {
        // Store login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_loginStateKey, true);
        return true;
      } catch (e) {
        log('Error saving login state: $e');
        return false;
      }
    }
    return false;
  }

  // Logout method
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginStateKey, false);
      return true;
    } catch (e) {
      log('Error clearing login state: $e');
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_loginStateKey) ?? false;
    } catch (e) {
      log('Error checking login state: $e');
      return false;
    }
  }
}