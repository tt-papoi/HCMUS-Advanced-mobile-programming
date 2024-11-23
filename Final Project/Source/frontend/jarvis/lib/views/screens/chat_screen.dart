import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jarvis/models/conversation.dart';
import 'package:jarvis/models/message.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/providers/chat_provider.dart';
import 'package:jarvis/widgets/chat_bar.dart';
import 'package:jarvis/widgets/remain_token.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final bool isNewChat;
  final Conversation conversation;

  const ChatScreen({
    super.key,
    required this.isNewChat,
    required this.conversation,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatProvider _chatProvider;
  late AuthProvider _authProvider;

  void _sendMessage(Message message) {
    _receiveMessage();
  }

  void _receiveMessage() {}

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    _chatProvider.isLoading = true;
    await _chatProvider.fetchChatHistory(
        accessToken: _authProvider.accessToken!,
        conversationId: widget.conversation.conversationId);
  }

  @override
  void dispose() {
    _chatProvider.clearChatHistories();
    super.dispose();
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
              widget.conversation.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: const [
          RemainToken(),
        ],
      ),
      body: Consumer<ChatProvider>(builder: (context, chatProvider, child) {
        if (chatProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatProvider.messages.length,
                itemBuilder: (context, index) {
                  return _displayMessageContainer(
                      _chatProvider.messages[index]);
                },
              ),
            ),
            ChatBar(
              hintMessage: 'Message',
              onSendMessage: _sendMessage,
            ),
          ],
        );
      }),
    );
  }

  Widget _displayMessageContainer(Message message) {
    bool isUserMessage = message.role == Role.user;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment:
            isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isUserMessage) _displayUserInfo() else _displayBotInfo(),
          _displayMessageContent(message),
        ],
      ),
    );
  }

  Widget _displayBotInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            "lib/assets/icons/logo_blueAccent.png",
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          const Text("Jarvis", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _displayUserInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("You", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.blueAccent,
            child: Icon(
              Icons.person_2_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayMessageContent(Message message) {
    return Column(
      crossAxisAlignment: message.role == Role.user
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            color:
                message.role == Role.user ? Colors.blue[50] : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.content != "") _displayTextMessage(message.content),
              if (message.file != null)
                _displayImage(message.role, message.file!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _displayTextMessage(String message) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _displayImage(Role type, File image) {
    return type == Role.user
        ? Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Image.file(image, fit: BoxFit.cover),
          )
        : Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Image.file(image),
          );
  }

  // Widget _displayCode(String code) {
  //   return Container(
  //     margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
  //     decoration: BoxDecoration(
  //       color: const Color.fromARGB(200, 0, 0, 0),
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(12),
  //           child: const Text(
  //             "Code",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.black87,
  //             borderRadius: BorderRadius.only(
  //               bottomLeft: Radius.circular(8),
  //               bottomRight: Radius.circular(8),
  //             ),
  //           ),
  //           padding: const EdgeInsets.all(12.0),
  //           child: Text(
  //             code,
  //             style: const TextStyle(
  //                 fontFamily: 'monospace',
  //                 color: Color.fromARGB(255, 255, 255, 255)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
