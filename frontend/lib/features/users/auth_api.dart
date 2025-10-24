import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/core/api.dart';

class AuthApi {
  final base = "${ApiConfig.baseUrl}/api/auth";

  Future<String> signup(String name, String email, String password) async {
    final r = await http.post(
      Uri.parse("$base/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    if (r.statusCode != 200) {
      throw Exception(jsonDecode(r.body)['error'] ?? "Signup failed");
    }
    final body = jsonDecode(r.body);
    return body['token'];
  }

  Future<String> login(String email, String password) async {
    final r = await http.post(
      Uri.parse("$base/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (r.statusCode != 200) {
      throw Exception(jsonDecode(r.body)['error'] ?? "Login failed");
    }
    final body = jsonDecode(r.body);
    return body['token'];
  }
}
