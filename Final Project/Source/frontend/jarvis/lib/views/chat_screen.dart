import 'package:flutter/material.dart';
import 'package:jarvis/models/chat_info.dart';
import 'package:jarvis/widgets/chat_bar.dart';
import 'package:jarvis/widgets/remain_token.dart';
import 'dart:io';

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
  List<Widget> messages = [];

  get isNewChat => widget.isNewChat;

  void _sendMessage(String message, File? imageFile) {
    setState(() {
      if (imageFile != null) {
        messages.add(ListTile(
          title: Image.file(imageFile), // Display the selected image
        ));
      }
      messages.add(ListTile(title: Text(message))); // Add the text message
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.chatInfo.latestMessage.isNotEmpty) {
      messages.add(ListTile(title: Text(widget.chatInfo.latestMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
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
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index]; // Display messages
              },
            ),
          ),
          ChatBar(
            hintMessage: 'Message',
            onSendMessage: _sendMessage, // Send text and image
            onImageSelected: (File image) {
              // Handle image selection
              // Not needed anymore as it's handled in onSendMessage
            },
          ),
        ],
      ),
    );
  }
}
