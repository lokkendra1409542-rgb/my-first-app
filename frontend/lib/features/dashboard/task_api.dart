import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/core/api.dart';
import 'package:my_first_app/core/auth_store.dart';

class TaskApi {
  final String _base = "${ApiConfig.baseUrl}/api/tasks";

  Future<Map<String, String>> _headers() async {
    final token = await AuthStore.getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    // Note: if token is null, server will 401 (not logged in)
  }

  /// GET /api/tasks
  Future<List<Map<String, dynamic>>> list() async {
    final res = await http
        .get(Uri.parse(_base), headers: await _headers())
        .timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) {
      throw Exception("Load failed (${res.statusCode}): ${res.body}");
    }

    final decoded = jsonDecode(res.body);
    return (decoded as List).cast<Map<String, dynamic>>();
  }

  /// POST /api/tasks
  /// body: { title, description, status, priority }
  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final res = await http
        .post(
          Uri.parse(_base),
          headers: await _headers(),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) {
      throw Exception("Create failed (${res.statusCode}): ${res.body}");
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// PUT /api/tasks/:id
  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> body,
  ) async {
    final res = await http
        .put(
          Uri.parse("$_base/$id"),
          headers: await _headers(),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) {
      throw Exception("Update failed (${res.statusCode}): ${res.body}");
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// DELETE /api/tasks/:id
  Future<void> delete(String id) async {
    final res = await http
        .delete(Uri.parse("$_base/$id"), headers: await _headers())
        .timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) {
      throw Exception("Delete failed (${res.statusCode}): ${res.body}");
    }
  }
}
