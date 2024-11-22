import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../models/chat_info.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ChatInfo> _chatList = [];
  Map<String, List<ChatMessage>> _chatHistories = {};
  bool _isLoading = false;
  String? _nextCursor;

  List<ChatInfo> get chatList => _chatList;
  Map<String, List<ChatMessage>> get chatHistories => _chatHistories;
  bool get isLoading => _isLoading;
  bool get hasMore => _nextCursor != null;

  /// 1. Fetch all chat conversations
  Future<void> fetchChats(String accessToken, {bool loadMore = false}) async {
    if (loadMore && _nextCursor == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final result = await _chatService.fetchAllChats(
        accessToken: accessToken,
        cursor: loadMore ? _nextCursor : null,
      );
      print('API result: ${result['items']}');
      if (loadMore) {
        _chatList.addAll(result['item'] as List<ChatInfo>);
      } else {
        _chatList = result['item'] as List<ChatInfo>;
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

      final newChat = ChatInfo.fromJson(response);
      _chatList.insert(0, newChat);
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
        jarvisGuid: jarvisGuid,
      );

      final messages = (result['messages'] as List)
          .map((msg) => ChatMessage.fromJson(msg))
          .toList();

      if (loadMore && _chatHistories.containsKey(conversationId)) {
        _chatHistories[conversationId]?.addAll(messages);
      } else {
        _chatHistories[conversationId] = messages;
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

      final newMessage = ChatMessage.fromJson(response);

      // Add to local history
      _chatHistories[conversationId]?.add(newMessage);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Clear chat histories
  void clearChatHistories() {
    _chatHistories = {};
    _nextCursor = null;
    notifyListeners();
  }

  void clearChats() {
    _chatList = [];
    _nextCursor = null;
    notifyListeners();
  }
}
