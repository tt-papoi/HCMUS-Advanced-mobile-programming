// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:jarvis/models/bot.dart';

class ChatInfo {
  Bot bot;
  String mainContent;
  String latestMessage;
  DateTime latestActiveDate;

  ChatInfo({
    required this.bot,
    required this.mainContent,
    required this.latestMessage,
    required this.latestActiveDate,
  });
}
