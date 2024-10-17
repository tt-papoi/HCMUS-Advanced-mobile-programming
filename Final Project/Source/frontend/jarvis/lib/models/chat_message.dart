import 'package:flutter/material.dart';

class ChatMessage {
  String? message;
  final MessageType messageType;
  ImageProvider? image;

  ChatMessage({
    this.message,
    required this.messageType,
    this.image,
  });
}

enum MessageType { user, bot }
