import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class ContactsService {
  Future<List<User>> fetchContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final res = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/contacts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list
          .map((e) => User(
                id: e['id'] as String,
                username: e['username'] as String,
                email: e['email'] as String?,
              ))
          .toList();
    }
    return [];
  }
} 