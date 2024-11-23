import 'package:flutter/material.dart';
import 'package:jarvis/models/assistant.dart';
import '../services/chat_service.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<Conversation> _conversationList = [];
  List<Message> _messages = [];
  bool isLoading = false;
  String? _nextCursor;

  Conversation? currentConversation;

  Assistant selectedAssistant = Assistant(
    id: 'gpt-4o-mini',
    name: 'GPT-4o Mini',
    model: 'dify',
  );

  List<Conversation> get conversationList => _conversationList;
  List<Message> get messages => _messages;

  bool get hasMore => _nextCursor != null;

  /// 1. Fetch all chat conversations
  Future<void> fetchChats(String accessToken,
      {bool loadMore = false, int limit = 20}) async {
    if (loadMore && _nextCursor == null) return;

    try {
      isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  /// 2. Send a new message to start a conversation
  Future<void> startNewChat({
    required String accessToken,
    required String content,
    required Assistant assistant,
  }) async {
    try {
      final response = await _chatService.startNewChat(
        accessToken: accessToken,
        content: content,
        assistant: assistant,
      );

      currentConversation = Conversation(
        conversationId: response['conversationId'],
        title: content,
        createdAt: DateTime.now(),
      );
      currentConversation!.messages = <Message>[];
      currentConversation!.messages!.add(Message(
        content: content,
        role: Role.user,
      ));
      currentConversation!.messages!.add(Message(
        content: response['message'],
        role: Role.model,
      ));
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
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

      isLoading = true;

      final result = await _chatService.fetchChatHistory(
        accessToken: accessToken,
        conversationId: conversationId,
        assistantId: assistantId,
        assistantModel: assistantModel,
      );

      currentConversation = Conversation(
        conversationId: conversationId,
        title: '',
        createdAt: DateTime.now(),
      );

      for (var item in result['messages']) {
        List<Message> res = Message.fromJson(item);
        currentConversation!.messages!.add(res[0]);
        currentConversation!.messages!.add(res[1]);
      }

      _nextCursor = result['nextCursor'];
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
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
      // final response = await _chatService.sendFollowUpMessage(
      //   accessToken: accessToken,
      //   conversationId: conversationId,
      //   content: content,
      //   assistantId: assistantId,
      //   assistantModel: assistantModel,
      //   messages: messages,
      //   jarvisGuid: jarvisGuid,
      // );

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
