// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class ChatMessage {
  String textMessage;
  final MessageType messageType;
  File? image;
  String? code;
  DateTime sendTime;

  ChatMessage({
    required this.textMessage,
    required this.messageType,
    this.image,
    this.code,
    required this.sendTime,
  });
}

enum MessageType { user, bot }
