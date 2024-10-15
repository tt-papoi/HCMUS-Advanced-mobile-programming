import 'package:flutter/material.dart';
import 'package:jarvis/models/chat_info.dart';
import 'package:jarvis/widgets/chat_bar.dart';
import 'package:jarvis/widgets/remain_token.dart';

class ChatScreen extends StatefulWidget {
  final bool isNewChat;
  final ChatInfo chatInfo;

  const ChatScreen({
    super.key,
    required this.isNewChat,
    required this.chatInfo,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];

  get isNewChat => widget.isNewChat;

  void _sendMessage(String message) {
    setState(() {
      messages.add(message); // Add the new message to the list
    });
  }

  @override
  void initState() {
    super.initState();
    messages.add(widget.chatInfo.latestMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isNewChat ? "New chat" : widget.chatInfo.mainContent,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.chatInfo.bot.name,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: const [
          RemainToken(),
        ],
      ),
      body: Column(
        children: [
          // Expanded to display chat messages
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          // Chat bar for sending messages
          ChatBar(
            hintMessage: 'Message',
            onSendMessage: _sendMessage, // Pass the sending function
          ),
        ],
      ),
    );
  }
}
