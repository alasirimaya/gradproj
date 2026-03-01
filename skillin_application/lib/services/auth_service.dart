import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = "http://127.0.0.1:8000";
  static const String _tokenKey = "access_token";

  // Secure storage: iOS Keychain / Android Keystore
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/api/v1/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email.trim(),
        "password": password,
      }),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data["access_token"]?.toString();

      if (token == null || token.isEmpty) {
        return {"ok": false, "msg": "No token returned"};
      }

      await _storage.write(key: _tokenKey, value: token);
      return {"ok": true, "token": token};
    }

    String msg = "Login failed";
    try {
      final err = jsonDecode(response.body);
      if (err is Map && err["detail"] != null) msg = err["detail"].toString();
    } catch (_) {}

    return {"ok": false, "msg": msg, "status": response.statusCode};
  }

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/api/v1/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName.trim(),
        "email": email.trim(),
        "password": password,
      }),
    );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"ok": true};
    }

    String msg = "Register failed";
    try {
      final err = jsonDecode(response.body);
      if (err is Map && err["detail"] != null) msg = err["detail"].toString();
    } catch (_) {}

    return {"ok": false, "msg": msg, "status": response.statusCode};
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }

  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}