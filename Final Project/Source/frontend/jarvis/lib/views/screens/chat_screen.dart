import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jarvis/models/chat_info.dart';
import 'package:jarvis/models/chat_message.dart';
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
  List<ChatMessage> listMessages = [];

  void _sendMessage(ChatMessage message) {
    setState(() {
      listMessages.add(message);
    });
    _receiveMessage();
  }

  void _receiveMessage() {
    ChatMessage message = ChatMessage(
      textMessage: "Coming soon!",
      messageType: MessageType.model,
      file: null,
    );
    setState(() {
      listMessages.add(message);
    });
  }

  @override
  void initState() {
    super.initState();
    listMessages.add(widget.chatInfo.latestMessage);
    _receiveMessage();
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
              widget.isNewChat ? "New chat" : widget.chatInfo.mainContent,
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
              itemCount: listMessages.length,
              itemBuilder: (context, index) {
                return _displayMessageContainer(listMessages[index]);
              },
            ),
          ),
          ChatBar(
            hintMessage: 'Message',
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _displayMessageContainer(ChatMessage message) {
    bool isUserMessage = message.messageType == MessageType.user;

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
            widget.chatInfo.bot.imagePath,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Text(widget.chatInfo.bot.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _displayMessageContent(ChatMessage message) {
    return Column(
      crossAxisAlignment: message.messageType == MessageType.user
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            color: message.messageType == MessageType.user
                ? Colors.blue[50]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.textMessage != "")
                _displayTextMessage(message.textMessage),
              if (message.file != null)
                _displayImage(message.messageType, message.file!),
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

  Widget _displayImage(MessageType type, File image) {
    return type == MessageType.user
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
