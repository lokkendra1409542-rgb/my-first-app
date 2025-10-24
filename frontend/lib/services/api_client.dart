import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/env.dart';

final _headers = {'Content-Type': 'application/json'};

Future<List<dynamic>> getItems() async {
  final r = await http.get(Uri.parse('$apiBase/api/items'));
  if (r.statusCode != 200) throw Exception('GET failed: ${r.statusCode}');
  return jsonDecode(r.body) as List<dynamic>;
}

Future<Map<String, dynamic>> getItem(String id) async {
  final r = await http.get(Uri.parse('$apiBase/api/items/$id'));
  if (r.statusCode != 200) throw Exception('GET/:id failed: ${r.statusCode}');
  return jsonDecode(r.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> createItem(Map<String, dynamic> body) async {
  final r = await http.post(
    Uri.parse('$apiBase/api/items'),
    headers: _headers,
    body: jsonEncode(body),
  );
  if (r.statusCode != 201)
    throw Exception('POST failed: ${r.statusCode} ${r.body}');
  return jsonDecode(r.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> updateItem(
  String id,
  Map<String, dynamic> patch,
) async {
  final r = await http.patch(
    Uri.parse('$apiBase/api/items/$id'),
    headers: _headers,
    body: jsonEncode(patch),
  );
  if (r.statusCode != 200)
    throw Exception('PATCH failed: ${r.statusCode} ${r.body}');
  return jsonDecode(r.body) as Map<String, dynamic>;
}

Future<void> deleteItem(String id) async {
  final r = await http.delete(Uri.parse('$apiBase/api/items/$id'));
  if (r.statusCode != 200)
    throw Exception('DELETE failed: ${r.statusCode} ${r.body}');
}
