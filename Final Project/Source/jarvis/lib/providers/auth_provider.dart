import 'package:jarvis/services/auth_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();

  String? _accessToken;
  String? _refreshToken;
  String? _kbToken;
  String? userId;
  String? username;
  String? email;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get kbToken => _kbToken;

  bool get isLoggedIn => _accessToken != null || _refreshToken != null;

  Future<void> signInToKnowledgeBase() async {
    if (_accessToken == null) {
      throw Exception('Access token is missing. Please log in first.');
    }

    try {
      await refreshAccessToken();
      final response =
          await _authService.externalSignInToKnowledgeBase(_accessToken!);
      if (response.containsKey('token')) {
        _kbToken = response['token']['accessToken']; // Đây là kb_token
        await _storageService.saveKbToken(_kbToken!);
        if (kDebugMode) {
          print('Knowledge Base Sign-In Successful: $_kbToken');
        }
      } else {
        throw Exception('Token for Knowledge Base not found in response');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing in to Knowledge Base: $e');
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _authService.signIn(email, password);

      _accessToken = response['token']['accessToken'];
      _refreshToken = response['token']['refreshToken'];

      await _storageService.saveAccessToken(_accessToken!);
      await _storageService.saveRefreshToken(_refreshToken!);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadTokens() async {
    _accessToken = await _storageService.getAccessToken();
    _refreshToken = await _storageService.getRefreshToken();
    _kbToken = await _storageService.getKbToken();
    notifyListeners();
  }

  Future<void> refreshAccessToken() async {
    if (_refreshToken == null) return;

    try {
      final response = await _authService.refreshToken(_refreshToken!);

      _accessToken = response['token']['accessToken'];

      await _storageService.saveAccessToken(_accessToken!);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      await _authService.signUp(email, password, username);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;

    await _storageService.clearTokens();
    notifyListeners();
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    await refreshAccessToken();
    if (_accessToken == null) throw Exception('No access token available');

    final response = await _authService.getCurrentUser(_accessToken!);
    userId = response['id'];
    username = response['username'];
    email = response['email'];
    await _storageService.saveUserId(response['id']);
    return response;
  }
}
