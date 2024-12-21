import 'package:flutter/foundation.dart';
import 'package:jarvis/models/unit.dart';
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/services/kb_service.dart';
import 'package:jarvis/providers/auth_provider.dart';

class KnowledgeBaseProvider with ChangeNotifier {
  final KnowledgeBaseService _knowledgeBaseService = KnowledgeBaseService();
  List<KnowledgeSource> _knowledgeSources = [];
  List<Unit> _units = [];
  bool _isLoading = false;

  List<KnowledgeSource> get knowledgeSources => _knowledgeSources;
  List<Unit> get units => _units;
  bool get isLoading => _isLoading;

  Future<void> createKnowledgeBase({
    required String knowledgeName,
    required String description,
    required AuthProvider authProvider, // Lấy accessToken từ AuthProvider
  }) async {
    final accessToken =
        authProvider.kbToken; // Lấy access token từ AuthProvider
    if (accessToken == null) throw Exception("Access token is not available");

    _isLoading = true;
    notifyListeners();

    try {
      await _knowledgeBaseService.createKnowledgeBase(
        token: accessToken,
        knowledgeName: knowledgeName,
        description: description,
      );

      //_knowledgeSources.add(KnowledgeSource.fromJson(response['data']));
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchKnowledgeBases(AuthProvider authProvider) async {
    try {
      await authProvider.refreshAccessToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing access token: $e');
      }
      rethrow;
    }
    final accessToken = authProvider.kbToken;
    if (accessToken == null) throw Exception("Access token is not available");

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _knowledgeBaseService.getKnowledgeBase(
        token: accessToken,
      );
      _knowledgeSources = data['data'] as List<KnowledgeSource>;
      for (var knowledgeSource in _knowledgeSources) {
        print(knowledgeSource.id);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateKnowledgeBase({
    required String id,
    required String knowledgeName,
    required String description,
    required AuthProvider authProvider,
  }) async {
    final accessToken =
        authProvider.kbToken; // Lấy access token từ AuthProvider
    if (accessToken == null) throw Exception("Access token is not available");

    _isLoading = true;
    notifyListeners();

    try {
      await _knowledgeBaseService.updateKnowledgeBase(
        token: accessToken,
        id: id,
        knowledgeName: knowledgeName,
        description: description,
      );
    } catch (e) {
      throw Exception('Error updating Knowledge Base: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteKnowledgeBase({
    required String id,
    required AuthProvider authProvider,
  }) async {
    final accessToken =
        authProvider.kbToken; // Lấy access token từ AuthProvider
    if (accessToken == null) throw Exception("Access token is not available");

    _isLoading = true;
    notifyListeners();

    try {
      await _knowledgeBaseService.deleteKnowledgeBase(
        token: accessToken,
        id: id,
      );
    } catch (e) {
      throw Exception('Error deleting Knowledge Base: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUnitKnowledge({
    required String id,
    required AuthProvider authProvider,
  }) async {
    final accessToken =
        authProvider.kbToken; // Lấy access token từ AuthProvider
    if (accessToken == null) throw Exception("Access token is not available");

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _knowledgeBaseService.getUnitKnowledge(
        token: accessToken,
        id: id,
      );
      print(response);
      _units = response['units'] as List<Unit>;

      for (var unit in _units) {
        print('Unit Name: ${unit.name}');
      }
    } catch (e) {
      throw Exception('Error getting unit knowledge: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUnit({
    required String token,
    required String id,
    required String unitType, // Loại unit (web, slack, confluence, ...)
    required String unitName,
    required Map<String, dynamic> unitData, // Dữ liệu động cho từng loại unit
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      switch (unitType) {
        case 'web':
          print(unitData['webUrl']);
          await _knowledgeBaseService.addWebUnit(
            token: token,
            id: id,
            unitName: unitName,
            webUrl: unitData['webUrl'],
          );
          print(2);
          break;

        case 'slack':
          await _knowledgeBaseService.addSlackUnit(
            token: token,
            id: id,
            unitName: unitName,
            slackWorkspace: unitData['slackWorkspace'],
            slackbotToken: unitData['slackbotToken'],
          );
          break;

        case 'confluence':
          await _knowledgeBaseService.addConfluenceUnit(
            token: token,
            id: id,
            unitName: unitName,
            wikiPageUrl: unitData['wikiPageUrl'],
            confluenceUsername: unitData['confluenceUsername'],
            confluenceAccessToken: unitData['confluenceAccessToken'],
          );
          break;

        default:
          throw Exception('Unsupported unit type: $unitType');
      }
    } catch (e) {
      throw Exception('Error adding unit: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
