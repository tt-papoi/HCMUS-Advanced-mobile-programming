import 'package:flutter/foundation.dart';
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/services/kb_service.dart';
import 'package:jarvis/providers/auth_provider.dart';

class KnowledgeBaseProvider with ChangeNotifier {
  final KnowledgeBaseService _knowledgeBaseService = KnowledgeBaseService();
  List<dynamic> _knowledgeBases = [];
  bool _isLoading = false;

//   List<KnowledgeSource> _knowledgeSources = [];
// List<KnowledgeSource> get knowledgeSources => _knowledgeSources;
  List<dynamic> get knowledgeBases => _knowledgeBases;

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
      final response = await _knowledgeBaseService.createKnowledgeBase(
        token: accessToken,
        knowledgeName: knowledgeName,
        description: description,
      );

      print('Knowledge Base created successfully: $response');
    } catch (e) {
      print('Error creating Knowledge Base: $e');

      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchKnowledgeBases(AuthProvider authProvider) async {
    final accessToken = authProvider.kbToken;
    if (accessToken == null) throw Exception("Access token is not available");

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _knowledgeBaseService.getKnowledgeBase(
        token: accessToken,
      );
      _knowledgeBases = data['data'];
      print('Knowledge Bases fetched successfully: $data');
      //_knowledgeBases = data;
    } catch (e) {
      print("Error fetching Knowledge Bases: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
