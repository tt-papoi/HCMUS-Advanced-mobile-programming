import 'chat_message.dart';
import 'bot.dart';

class ChatInfo {
  final String conversationId; // Add conversation ID
  final String mainContent; // Main topic or title
  final ChatMessage latestMessage; // Last message in the chat
  final Bot bot; // Bot details
  final DateTime lastUpdated; // Timestamp for last update

  ChatInfo({
    required this.conversationId,
    required this.mainContent,
    required this.latestMessage,
    required this.bot,
    required this.lastUpdated,
  });

  /// Convert JSON to ChatInfo
  factory ChatInfo.fromJson(Map<String, dynamic> json) {
    return ChatInfo(
      conversationId: json['id'] as String,
      mainContent: json['mainContent'] as String,
      latestMessage: ChatMessage.fromJson(json['latestMessage']),
      bot: Bot.fromJson(json['bot']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Convert ChatInfo to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': conversationId,
      'mainContent': mainContent,
      'latestMessage': latestMessage.toJson(),
      'bot': bot.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
