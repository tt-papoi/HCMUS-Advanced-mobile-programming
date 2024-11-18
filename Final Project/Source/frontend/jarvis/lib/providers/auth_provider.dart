import 'package:jarvis/services/auth_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;

  bool get isLoggedIn {
    if (_refreshToken != null && _isTokenExpiredSync(_refreshToken!)) {
      return false;
    }
    if (_accessToken != null && _isTokenExpiredSync(_accessToken!)) {
      refreshAccessToken();
    }
    return _accessToken != null;
  }

  // Đăng nhập và lưu token
  Future<void> signIn(String email, String password) async {
    try {
      final response = await _authService.signIn(email, password);

      // Access the tokens from the response
      _accessToken = response['token']['accessToken'];
      _refreshToken = response['token']['refreshToken'];

      // Lưu vào secure storage
      await _storageService.saveAccessToken(_accessToken!);
      await _storageService.saveRefreshToken(_refreshToken!);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Lấy token từ storage khi khởi động ứng dụng
  Future<void> loadTokens() async {
    _accessToken = await _storageService.getAccessToken();
    _refreshToken = await _storageService.getRefreshToken();
    notifyListeners();
  }

  // Refresh token if expired
  Future<void> refreshAccessToken() async {
    if (_refreshToken == null) return;

    try {
      final response = await _authService.refreshToken(_refreshToken!);

      _accessToken = response['token']['accessToken'];

      // Save the new tokens
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

  Future<void> signOut() async {
    _accessToken = null;
    _refreshToken = null;

    await _storageService.clearTokens();
    notifyListeners();
  }

  // Automatic token refresh before making API calls
  Future<void> ensureValidToken() async {
    if (_accessToken == null || await _isTokenExpired(_accessToken!)) {
      await refreshAccessToken();
    }
  }

  // Helper method to check if the token is expired (JWT decoding)
  Future<bool> _isTokenExpired(String token) async {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true; // Invalid token format

      final payload = _decodeJWT(parts[1]);
      final expiryTime =
          DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

      return expiryTime.isBefore(DateTime.now());
    } catch (e) {
      return true; // Assume expired if error occurs
    }
  }

  // Synchronous helper method to check if the token is expired (JWT decoding)
  bool _isTokenExpiredSync(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true; // Invalid token format

      final payload = _decodeJWT(parts[1]);
      final expiryTime =
          DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

      return expiryTime.isBefore(DateTime.now());
    } catch (e) {
      return true; // Assume expired if error occurs
    }
  }

  // Decoding the JWT token
  Map<String, dynamic> _decodeJWT(String base64Str) {
    final normalized = base64Str.replaceAll('-', '+').replaceAll('_', '/');
    final decoded = base64.decode(normalized);
    return jsonDecode(utf8.decode(decoded));
  }
}
