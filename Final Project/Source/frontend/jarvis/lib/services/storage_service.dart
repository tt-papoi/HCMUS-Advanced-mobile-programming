import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  // Lưu Access Token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  // Lưu Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  // Lấy Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Lấy Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // Xóa Token
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
