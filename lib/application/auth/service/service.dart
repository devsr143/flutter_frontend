import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:8000/CustomLoginView';

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token']; 
        await storage.write(key: 'auth_token', value: token);
        await storage.write(key: 'username', value: username);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  
  Future<String?> getUsername() async {
    return await storage.read(key: 'username');
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }
  Future<Map<String, dynamic>?> getUserDetails() async {
  try {
    final token = await getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/user-details/'), // adjust endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch user details: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching user details: $e');
    return null;
  }
}
}