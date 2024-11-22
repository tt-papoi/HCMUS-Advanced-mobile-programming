import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis/models/message.dart';
import '../models/conversation.dart';
import 'package:jarvis/utils/constants.dart';

class ChatService {
  final String baseUrl = ProjectConstants.baseUrl;

  Future<Map<String, dynamic>> fetchAllChats({
    required String accessToken,
    String? cursor,
    int limit = 100,
    String assistantId = 'gpt-4o-mini',
    String assistantModel = 'dify',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai-chat/conversations').replace(
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
          'limit': '$limit',
          'assistantId': assistantId,
          'assistantModel': assistantModel,
        },
      );

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Kiểm tra nếu 'data' là null hoặc không phải danh sách
        final List<Conversation> chatList = [];
        for (var item in data['items']) {
          Conversation conversation = Conversation.fromJson(item);
          List<Message> messages = [];

          await fetchChatHistory(
            limit: 1,
            accessToken: accessToken,
            conversationId: conversation.conversationId,
            assistantId: assistantId,
            assistantModel: assistantModel,
          ).then((value) {
            for (var item in value['messages']) {
              List<Message> res = Message.fromJson(item);
              messages.add(res[0]);
              messages.add(res[1]);
            }
          });
          conversation.messages = messages;
          chatList.add(conversation);
        }
        return {
          'data': chatList,
          'nextCursor': data['nextCursor'],
        };
      } else {
        throw Exception(
          'Failed to fetch chats. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error in fetchAllChats: $e');
    }
  }

  /// 2. Send a message to start a new conversation
  Future<Map<String, dynamic>> sendMessage({
    required String accessToken,
    required String content,
    String assistantId = 'gpt-4o-mini',
    String assistantModel = 'dify',
    String? jarvisGuid, // optional x-jarvis-guid header
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai-chat');

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        if (jarvisGuid != null) 'x-jarvis-guid': jarvisGuid,
      };

      final body = json.encode({
        "assistant": {
          "id": assistantId,
          "model": assistantModel,
        },
        "content": content,
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
          'Failed to send message. Status code: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error in sendMessage: $e');
    }
  }

  /// 3. Fetch chat history of a conversation
  Future<Map<String, dynamic>> fetchChatHistory({
    required String accessToken,
    required String conversationId,
    int limit = 100,
    String assistantId = 'gpt-4o-mini',
    String assistantModel = 'dify',
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/api/v1/ai-chat/conversations/$conversationId/messages',
      ).replace(queryParameters: {
        'limit': '$limit',
        'assistantId': assistantId,
        'assistantModel': assistantModel,
      });

      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'messages': data['items'],
          'nextCursor': data['cursor'],
        };
      } else {
        throw Exception(
          'Failed to fetch chat history. Status code: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error in fetchChatHistory: $e');
    }
  }

  /// 4. Send a follow-up message in an existing conversation
  Future<Map<String, dynamic>> sendFollowUpMessage({
    required String accessToken,
    required String conversationId,
    required String content,
    required String assistantId,
    String assistantModel = 'dify',
    List<Map<String, dynamic>>? messages, // Optional history
    String? jarvisGuid,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai-chat/messages');

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        if (jarvisGuid != null) 'x-jarvis-guid': jarvisGuid,
      };

      final body = json.encode({
        "content": content,
        "metadata": {
          "conversation": {
            "id": conversationId,
            "messages": messages ?? [],
          }
        },
        "assistant": {
          "id": assistantId,
          "model": assistantModel,
        }
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
          'Failed to send follow-up message. Status code: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error in sendFollowUpMessage: $e');
    }
  }
}
