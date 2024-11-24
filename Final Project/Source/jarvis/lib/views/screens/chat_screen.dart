// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jarvis/models/conversation.dart';
import 'package:jarvis/models/message.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/providers/chat_provider.dart';
import 'package:jarvis/widgets/assistants_bar.dart';
import 'package:jarvis/widgets/chat_bar.dart';
import 'package:jarvis/widgets/remain_token.dart';

class ChatScreen extends StatefulWidget {
  final bool isNewChat;
  final Conversation? conversation;
  final Message? newMessage;

  const ChatScreen({
    super.key,
    required this.isNewChat,
    this.conversation,
    this.newMessage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatProvider _chatProvider;
  late AuthProvider _authProvider;

  // Define a GlobalKey for AssistantBar
  final GlobalKey<AssistantBarState> assistantBarKey =
      GlobalKey<AssistantBarState>();

  // ValueNotifier to manage AssistantBar visibility
  final ValueNotifier<bool> _isAssistantBarVisible = ValueNotifier<bool>(true);

  void _sendMessage(Message message) async {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    await _authProvider.refreshAccessToken();

    try {
      await _chatProvider.sendFollowUpMessage(
        accessToken: _authProvider.accessToken!,
        conversationId: _chatProvider.currentConversation!.conversationId,
        content: message.content,
        assistantId: _chatProvider.selectedAssistant.id,
        assistantModel: _chatProvider.selectedAssistant.model,
      );
    } catch (e) {
      debugPrint('Error while sending message: $e');
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (widget.isNewChat) {
      _chatProvider.isLoading = true;
      _chatProvider.messages.add(widget.newMessage!);

      await _authProvider.refreshAccessToken();
      await _chatProvider.startNewChat(
          accessToken: _authProvider.accessToken!,
          assistant: _chatProvider.selectedAssistant,
          content: widget.newMessage!.content);
    } else {
      _chatProvider.isLoading = true;
      await _chatProvider.fetchChatHistory(
          accessToken: _authProvider.accessToken!,
          conversationId: widget.conversation!.conversationId);
    }
  }

  @override
  void dispose() {
    _chatProvider.clearChatHistories();
    _chatProvider.currentConversation = null;
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
              widget.isNewChat ? "New chat" : widget.conversation!.title,
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
                itemCount: _chatProvider.currentConversation!.messages?.length,
                itemBuilder: (context, index) {
                  return _displayMessageContainer(
                      _chatProvider.currentConversation!.messages![index]);
                },
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isAssistantBarVisible,
              builder: (context, isVisible, child) {
                return isVisible
                    ? AssistantBar(key: assistantBarKey)
                    : Container();
              },
            ),
            ChatBar(
              hintMessage: 'Message',
              onSendMessage: _sendMessage,
              onSlashTyped: (bool isSlashTyped) {
                _isAssistantBarVisible.value = !isSlashTyped;
              },
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
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final selectedAssistant = chatProvider.selectedAssistant;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            selectedAssistant.imagePath ?? 'assets/default_image.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Text(
            selectedAssistant.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
}
