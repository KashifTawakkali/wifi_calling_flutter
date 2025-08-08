import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AuthService {
  String? _token;

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token != null;
  }

  Future<bool> login(String usernameOrEmail, String password) async {
    final url = Uri.parse('${Constants.apiBaseUrl}/auth/login');
    print('AuthService.login -> POST $url');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      }),
    );
    print('AuthService.login <- status ${res.statusCode}');

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final token = body['token'] as String;
      final user = body['user'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user', jsonEncode(user));
      _token = token;
      return true;
    } else {
      print('AuthService.login error body: ${res.body}');
    }
    return false;
  }

  Future<bool> register(String usernameOrEmail, String password) async {
    final isEmail = usernameOrEmail.contains('@');
    final url = Uri.parse('${Constants.apiBaseUrl}/auth/register');
    print('AuthService.register -> POST $url');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': isEmail ? usernameOrEmail.split('@').first : usernameOrEmail,
        'email': isEmail ? usernameOrEmail : '${usernameOrEmail}@example.com',
        'password': password,
      }),
    );
    print('AuthService.register <- status ${res.statusCode}');

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final token = body['token'] as String;
      final user = body['user'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user', jsonEncode(user));
      _token = token;
      return true;
    } else {
      print('AuthService.register error body: ${res.body}');
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
  }

  Future<String?> get token async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }
}