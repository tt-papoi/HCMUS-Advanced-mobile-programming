import 'package:flutter/material.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/services/token_service.dart';

class TokenProvider with ChangeNotifier {
  final TokenService _tokenService = TokenService();
  final AuthProvider authProvider = AuthProvider();
  Map<String, dynamic>? _tokenUsage;
  Map<String, dynamic>? get tokenUsage => _tokenUsage;

  // Fetch token usage using the TokenService
  Future<void> fetchTokenUsage(String accessToken) async {
    try {
      final response = await _tokenService.fetchTokenUsage(accessToken);
      _tokenUsage = response;

      notifyListeners();
    } catch (e) {
      throw Exception('Error in fetchTokenUsage: $e');
    }
  }
}
