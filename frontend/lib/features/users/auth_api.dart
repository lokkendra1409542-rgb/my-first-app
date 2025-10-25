import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/core/api.dart';

class AuthApi {
  final String base = "${ApiConfig.baseUrl}/api/auth";

  /// Sign up → returns JWT token
  Future<String> signup(String name, String email, String password) async {
    final uri = Uri.parse("$base/signup");
    final res = await http
        .post(
          uri,
          headers: const {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
          }),
        )
        .timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) {
      try {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? "Signup failed (${res.statusCode})");
      } catch (_) {
        throw Exception("Signup failed (${res.statusCode})");
      }
    }

    final body = jsonDecode(res.body);
    final token = body['token'];
    if (token == null || token is! String) {
      throw Exception("Invalid signup response: token missing");
    }
    return token;
  }

  /// Login → returns JWT token
  Future<String> login(String email, String password) async {
    final uri = Uri.parse("$base/login");
    final res = await http
        .post(
          uri,
          headers: const {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}),
        )
        .timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) {
      try {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? "Login failed (${res.statusCode})");
      } catch (_) {
        throw Exception("Login failed (${res.statusCode})");
      }
    }

    final body = jsonDecode(res.body);
    final token = body['token'];
    if (token == null || token is! String) {
      throw Exception("Invalid login response: token missing");
    }
    return token;
  }
}
