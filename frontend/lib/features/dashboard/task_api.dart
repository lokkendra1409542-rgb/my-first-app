import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/core/api.dart';
import 'package:my_first_app/core/auth_store.dart';

class TaskApi {
  final _base = "${ApiConfig.baseUrl}/api/tasks";

  Future<Map<String, String>> _headers() async {
    final t = await AuthStore.getToken();
    return {
      "Content-Type": "application/json",
      if (t != null) "Authorization": "Bearer $t",
    };
  }

  Future<List<Map<String, dynamic>>> list() async {
    final r = await http.get(Uri.parse(_base), headers: await _headers());
    if (r.statusCode != 200) throw Exception("Load failed: ${r.body}");
    return (jsonDecode(r.body) as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final r = await http.post(
      Uri.parse(_base),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (r.statusCode != 200) throw Exception("Create failed: ${r.body}");
    return jsonDecode(r.body);
  }

  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> body,
  ) async {
    final r = await http.put(
      Uri.parse("$_base/$id"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (r.statusCode != 200) throw Exception("Update failed: ${r.body}");
    return jsonDecode(r.body);
  }

  Future<void> delete(String id) async {
    final r = await http.delete(
      Uri.parse("$_base/$id"),
      headers: await _headers(),
    );
    if (r.statusCode != 200) throw Exception("Delete failed: ${r.body}");
  }
}
