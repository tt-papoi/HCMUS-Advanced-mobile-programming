import 'package:jarvis/models/message.dart';

class Conversation {
  final String conversationId; // Add conversation ID
  final String title; // Main topic or title
  List<Message>? messages; // List of messages
  final DateTime createdAt; // Timestamp for last update

  Conversation({
    required this.conversationId,
    required this.title,
    required this.createdAt,
  }) {
    messages = <Message>[];
  }

  /// Convert JSON to ChatInfo
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: (json['conversationId'] ?? json['id']) as String,
      title: (json['title'] ?? json['message']) as String,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : DateTime.now(), // Sử dụng thời gian hiện tại nếu thiếu
    );
  }

  /// Convert ChatInfo to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': conversationId,
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
