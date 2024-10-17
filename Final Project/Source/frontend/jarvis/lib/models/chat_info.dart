// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/models/chat_message.dart';

class ChatInfo {
  Bot bot;
  String mainContent;
  ChatMessage latestMessage;

  ChatInfo({
    required this.bot,
    required this.mainContent,
    required this.latestMessage,
  });
}
