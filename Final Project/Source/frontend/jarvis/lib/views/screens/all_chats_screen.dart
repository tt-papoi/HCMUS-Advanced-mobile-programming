import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/models/chat_info.dart';
import 'package:jarvis/models/chat_message.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/dialogs/confirm_delete_dialog.dart';
import 'package:jarvis/views/screens/chat_screen.dart';
import 'package:jarvis/widgets/remain_token.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  final List<ChatInfo> chatInfoList = [
    ChatInfo(
      mainContent: 'Drawer Creation',
      latestMessage: ChatMessage(
        messageType: MessageType.bot,
        textMessage:
            'Để tránh hiệu ứng bị tràn ra khỏi border khi nhấn vào "Inkwell", bạn...',
        sendTime: DateTime(2024, 10, 11),
      ),
      bot: Bot(
        name: "Assistant",
        description: "AI Assistant",
        imagePath: 'lib/assets/icons/robot.png',
        id: '',
        botType: BotType.createdBot,
        prompt: 'You are my assistant',
      ),
    ),
    ChatInfo(
      mainContent: 'Hello',
      latestMessage: ChatMessage(
        messageType: MessageType.bot,
        textMessage:
            'I\'m afraid I don\'t understand. Could you please provide more context?',
        sendTime: DateTime(2024, 10, 8),
      ),
      bot: Bot(
        name: "GPT-4.0",
        description: "GPT-4.0",
        imagePath: 'lib/assets/icons/chatgpt_icon.png',
        id: '',
        botType: BotType.offical,
      ),
    ),
    ChatInfo(
      bot: Bot(
        name: "GPT-3.5",
        description: "GPT-3.5",
        imagePath: 'lib/assets/icons/chatgpt_icon.png',
        id: '',
        botType: BotType.offical,
      ),
      mainContent: 'Ajq',
      latestMessage: ChatMessage(
        messageType: MessageType.bot,
        textMessage:
            'I\'m afraid I don\'t understand. Could you please provide more context?',
        sendTime: DateTime(2024, 10, 7),
      ),
    ),
    ChatInfo(
      bot: Bot(
        name: "GPT-4.0-Turbo",
        description: "GPT-4.0-Turbo",
        imagePath: 'lib/assets/icons/chatgpt_icon.png',
        id: '',
        botType: BotType.offical,
      ),
      mainContent: 'Laughing',
      latestMessage: ChatMessage(
        messageType: MessageType.bot,
        textMessage: 'Hey there! What\'s on your mind?',
        sendTime: DateTime(2024, 10, 7),
      ),
    ),
  ];

  String formatDate(DateTime date) {
    return DateFormat('MMM dd').format(date); // Format date as "Oct 14"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "All chats",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: const [
          RemainToken(),
        ],
      ),
      body: ListView.separated(
        itemCount: chatInfoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            //Navigate to thread chat.
            onTap: () {
              Navigator.push(
                  context,
                  FadeRoute(
                      page: ChatScreen(
                    chatInfo: chatInfoList[index],
                    isNewChat: false,
                  )));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                chatInfoList[index].bot.name[0], // First letter of the botName
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatInfoList[index].bot.name,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  chatInfoList[index].mainContent,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  chatInfoList[index].latestMessage.textMessage,
                  maxLines: 1, // Truncate if too long
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatDate(chatInfoList[index].latestMessage.sendTime),
                  style: const TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmationDialog(context, index);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: const Text('Delete'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          indent: 0,
          thickness: 0,
          endIndent: 0,
          height: 0,
        ),
      ),
    );
  }

  void _deleteChat(int index) {
    setState(() {
      chatInfoList.removeAt(index);
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog<ChatInfo>(
          title: 'Delete chat',
          content: 'Are you sure you want to delete this chat?',
          onDelete: (chatInfo) {
            _deleteChat(index);
          },
          parameter: chatInfoList[index],
        );
      },
    );
  }
}
