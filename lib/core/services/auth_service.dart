import 'dart:async';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class AuthService extends ChangeNotifier {
  final StorageService _storageService;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthService(this._storageService) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _storageService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Mock API Call delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      await _storageService.saveToken('mock_jwt_token_123');
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // Mock API Call delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      await _storageService.saveToken('mock_jwt_token_123');
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    _isAuthenticated = false;
    notifyListeners();
  }
}
