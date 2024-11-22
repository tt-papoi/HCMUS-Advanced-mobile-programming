import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis/utils/constants.dart';

class TokenService {
  final String baseUrl = "${ProjectConstants.baseUrl}/api/v1/tokens/usage";

  Future<Map<String, dynamic>> fetchTokenUsage(String accessToken) async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            "Failed to fetch token usage: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching token usage: $e");
    }
  }
}
