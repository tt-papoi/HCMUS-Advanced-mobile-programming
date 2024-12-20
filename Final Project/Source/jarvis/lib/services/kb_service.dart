import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/utils/constants.dart';

class KnowledgeBaseService {
  final String kbUrl = "${ProjectConstants.kbUrl}/kb-core/v1/knowledge";

  Future<Map<String, dynamic>> createKnowledgeBase({
    required String token,
    required String knowledgeName,
    required String description,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "knowledgeName": knowledgeName,
      "description": description,
    });

    final response = await http.post(
      Uri.parse(kbUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to create Knowledge Base: ${response.reasonPhrase}');
    }
  }

  // Lấy danh sách Knowledge Base
  Future<Map<String, dynamic>> getKnowledgeBase({
    required String token,
    String? query,
    String order = 'DESC',
    String orderField = 'createdAt',
    int offset = 0,
    int limit = 20,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'x-jarvis-guid': '',
    };

    final uri = Uri.parse(
      '$kbUrl?query=${query ?? ''}&order=$order&orderField=$orderField&offset=$offset&limit=$limit',
    );

    final response = await http.get(uri, headers: headers);
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      print(jsonResponse['data']);
      // Chuyển đổi `data` thành danh sách KnowledgeSource
      final List<KnowledgeSource> knowledgeSources =
          (jsonResponse['data'] as List)
              .map((item) => KnowledgeSource.fromJson(item))
              .toList();

      // Chuyển đổi `meta` nếu cần
      //final MetaData metaData = MetaData.fromJson(jsonResponse['meta']);

      // Trả về cả data và metadata
      return {
        'data': knowledgeSources,
        //'meta': metaData,
      };
    } else {
      throw Exception('Failed to fetch Knowledge Base');
    }
  }
}
