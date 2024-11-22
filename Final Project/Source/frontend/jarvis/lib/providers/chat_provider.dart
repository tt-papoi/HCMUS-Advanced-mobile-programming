import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<Conversation> _conversationList = [];
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _nextCursor;

  List<Conversation> get conversationList => _conversationList;
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get hasMore => _nextCursor != null;

  /// 1. Fetch all chat conversations
  Future<void> fetchChats(String accessToken,
      {bool loadMore = false, int limit = 20}) async {
    if (loadMore && _nextCursor == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final result = await _chatService.fetchAllChats(
        accessToken: accessToken,
        cursor: loadMore ? _nextCursor : null,
        limit: limit,
      );

      final items = result['data'] as List<Conversation>? ?? [];
      if (loadMore) {
        _conversationList.addAll(items);
      } else {
        _conversationList = items;
      }

      _nextCursor = result['nextCursor'];
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 2. Send a new message to start a conversation
  Future<void> sendMessage({
    required String accessToken,
    required String content,
    String assistantId = 'gpt-4o-mini',
    String assistantModel = 'dify',
  }) async {
    try {
      final response = await _chatService.sendMessage(
        accessToken: accessToken,
        content: content,
        assistantId: assistantId,
        assistantModel: assistantModel,
      );

      final newChat = Conversation.fromJson(response);
      _conversationList.insert(0, newChat);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// 3. Fetch chat history for a specific conversation
  Future<void> fetchChatHistory({
    required String accessToken,
    required String conversationId,
    String assistantId = 'gpt-4o-mini',
    String assistantModel = 'dify',
    bool loadMore = false,
    String? jarvisGuid,
  }) async {
    try {
      if (loadMore && _nextCursor == null) return;

      _isLoading = true;
      notifyListeners();

      final result = await _chatService.fetchChatHistory(
        accessToken: accessToken,
        conversationId: conversationId,
        assistantId: assistantId,
        assistantModel: assistantModel,
      );

      for (var item in result['messages']) {
        List<Message> res = Message.fromJson(item);
        _messages.add(res[0]);
        _messages.add(res[1]);
      }

      _nextCursor = result['nextCursor'];
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 4. Send a follow-up message in an existing conversation
  Future<void> sendFollowUpMessage({
    required String accessToken,
    required String conversationId,
    required String content,
    String assistantId = 'gpt-4o-mini',
    String assistantModel = 'dify',
    List<Map<String, dynamic>>? messages, // Optional history
    String? jarvisGuid,
  }) async {
    try {
      final response = await _chatService.sendFollowUpMessage(
        accessToken: accessToken,
        conversationId: conversationId,
        content: content,
        assistantId: assistantId,
        assistantModel: assistantModel,
        messages: messages,
        jarvisGuid: jarvisGuid,
      );

      //final newMessage = Message.fromJson(response);

      // Add to local history
      //_chatHistories[conversationId]?.add(newMessage);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Clear chat histories
  void clearChatHistories() {
    _messages = [];
    _nextCursor = null;
  }

  void clearChats() {
    _conversationList = [];
    _nextCursor = null;
  }
}
