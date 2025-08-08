import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get userId => _currentUser?['id'] as String?;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();
    _isLoggedIn = await _authService.isUserLoggedIn();
    if (_isLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');
      if (userStr != null) {
        _currentUser = jsonDecode(userStr) as Map<String, dynamic>;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    bool success = await _authService.login(username, password);
    if (success) {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');
      if (userStr != null) _currentUser = jsonDecode(userStr);
    } else {
      _errorMessage = 'Invalid username or password.';
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    bool success = await _authService.register(username, password);
    if (success) {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');
      if (userStr != null) _currentUser = jsonDecode(userStr);
    } else {
      _errorMessage = 'Registration failed. Please try again.';
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _authService.logout();
    _isLoggedIn = false;
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}