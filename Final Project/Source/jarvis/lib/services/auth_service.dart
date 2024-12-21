import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis/utils/constants.dart';

class AuthService {
  final String baseUrl = "${ProjectConstants.baseUrl}/api/v1/auth";

  Future<Map<String, dynamic>> externalSignInToKnowledgeBase(
      String token) async {
    final headers = {
      'x-jarvis-guid': '',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "token": token,
    });

    final response = await http.post(
      Uri.parse('${ProjectConstants.kbUrl}/kb-core/v1/auth/external-sign-in'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to sign in to Knowledge Base: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch current user');
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign-in'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      // Decode the JSON response body
      Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the issue from the details array
      String? issue = data['details']?[0]['issue'];
      throw Exception(issue ?? 'Unknown error occurred');
    } else {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> googleSignIn(String googleToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/google-sign-in'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'googleToken': googleToken,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign in with Google');
    }
  }

  Future<Map<String, dynamic>> signUp(
      String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign-up'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      // Decode the JSON response body
      Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the issue from the details array
      String? issue = data['details']?[0]['issue'];
      throw Exception(issue ?? 'Unknown error occurred');
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/refresh?refreshToken=$refreshToken'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
