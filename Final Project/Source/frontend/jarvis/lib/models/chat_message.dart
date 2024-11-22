// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class ChatMessage {
  String textMessage;
  final MessageType messageType;
  File? file; // Optional file attachment

  ChatMessage({
    required this.textMessage,
    required this.messageType,
    this.file,
  });

  /// Convert JSON to ChatMessage
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      textMessage: json['content'] as String,
      messageType:
          json['role'] == 'user' ? MessageType.user : MessageType.model,
      file: json['files'] != null && json['files'].isNotEmpty
          ? File(json['files'][0]) // Use the first file if present
          : null,
    );
  }

  /// Convert ChatMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': textMessage,
      'role': messageType == MessageType.user ? 'user' : 'model',
      if (file != null) 'files': [file!.path], // Attach file path if present
    };
  }
}

enum MessageType { user, model }
