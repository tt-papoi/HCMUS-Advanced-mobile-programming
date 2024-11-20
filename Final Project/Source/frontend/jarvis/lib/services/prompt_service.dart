import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis/utils/constants.dart';

class PromptService {
  final String baseUrl = ProjectConstants.baseUrl;
  late String token;

  void setToken(String newToken) {
    token = newToken;
  }

  // Headers
  Map<String, String> getHeaders() {
    return {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Handle Response
  Future<dynamic> handleResponse(http.StreamedResponse response) async {}

  // Create Prompt
  Future<dynamic> createPrompt(Map<String, dynamic> data) async {
    var url = Uri.parse('$baseUrl/api/v1/prompts');
    var request = http.Request('POST', url);
    request.headers.addAll(getHeaders());
    request.body = json.encode(data);

    var response = await request.send();
    return await handleResponse(response);
  }

  // Get Prompts
  Future<dynamic> getPrompts(
      {String query = '',
      int offset = 0,
      int limit = 20,
      bool isFavorite = false,
      bool isPublic = true}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/v1/prompts?query=$query&offset=$offset&limit=$limit&isFavorite=$isFavorite&isPublic=$isPublic'),
      headers: getHeaders(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception("Error: $response");
    }
  }

  // Update Prompt
  Future<dynamic> updatePrompt(
      String promptId, Map<String, dynamic> data) async {
    var url = Uri.parse('$baseUrl/api/v1/prompts/$promptId');
    var request = http.Request('PATCH', url);
    request.headers.addAll(getHeaders());
    request.body = json.encode(data);

    var response = await request.send();
    return await handleResponse(response);
  }

  // Delete Prompt
  Future<dynamic> deletePrompt(String promptId) async {
    var url = Uri.parse('$baseUrl/api/v1/prompts/$promptId');
    var request = http.Request('DELETE', url);
    request.headers.addAll(getHeaders());

    var response = await request.send();
    return await handleResponse(response);
  }

  // Add Prompt to Favorite
  Future<dynamic> addPromptToFavorite(String promptId) async {
    var url = Uri.parse('$baseUrl/api/v1/prompts/$promptId/favorite');
    var request = http.Request('POST', url);
    request.headers.addAll(getHeaders());

    var response = await request.send();
    return await handleResponse(response);
  }

  // Remove Prompt from Favorite
  Future<dynamic> removePromptFromFavorite(String promptId) async {
    var url = Uri.parse('$baseUrl/api/v1/prompts/$promptId/favorite');
    var request = http.Request('DELETE', url);
    request.headers.addAll(getHeaders());

    var response = await request.send();
    return await handleResponse(response);
  }
}
