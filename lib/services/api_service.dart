import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<dynamic>> getPlaces() async {
    final response = await http.get(Uri.parse('$baseUrl/places'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load places');
    }
  }
}
