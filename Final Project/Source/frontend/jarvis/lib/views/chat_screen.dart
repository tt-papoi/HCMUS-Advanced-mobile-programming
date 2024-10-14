import 'package:flutter/material.dart';
import 'package:jarvis/widgets/chat_bar.dart';
import 'package:jarvis/widgets/remain_token.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Jarvis",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [
          RemainToken(),
        ],
      ),
      body: Column(
        children: [
          // This Expanded widget is for the top section
          Expanded(
            child: Container(),
          ),
          const ChatBar(),
        ],
      ),
    );
  }
}
