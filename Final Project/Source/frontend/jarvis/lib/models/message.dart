// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:jarvis/models/assistant.dart';

class Message {
  String content;
  final Role role;
  Assistant? assistant; // Optional bot information
  File? file; // Optional file attachment

  Message({
    required this.content,
    required this.role,
    this.file,
  });

  /// Convert JSON to ChatMessage
  static List<Message> fromJson(Map<String, dynamic> json) {
    return [
      Message(
        content: json['query'] as String,
        role: Role.user,
        file: null,
      ),
      Message(
        content: json['answer'] as String,
        role: Role.model,
        file: null,
      ),
    ];
  }

  /// Convert ChatMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role == Role.user ? 'user' : 'model',
      'files': [],
    };
  }
}

enum Role { user, model }
