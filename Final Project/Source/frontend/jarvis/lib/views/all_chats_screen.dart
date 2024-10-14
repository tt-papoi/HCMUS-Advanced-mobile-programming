import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis/models/chat_info.dart';
import 'package:jarvis/views/chat_screen.dart';
import 'package:jarvis/widgets/remain_token.dart';

class AllChatsScreen extends StatelessWidget {
  AllChatsScreen({super.key});

  final List<ChatInfo> chatMessages = [
    ChatInfo(
      botName: 'GPT-4o',
      botId: 'gpt-4o',
      mainContent: 'Drawer Creation',
      latestMessage:
          'Để tránh hiệu ứng bị tràn ra khỏi border khi nhấn vào "Inkwell", bạn...',
      latestActiveDate: DateTime(2024, 10, 11),
    ),
    ChatInfo(
      botName: 'BotC06G',
      botId: 'botc06g',
      mainContent: 'Hello',
      latestMessage:
          'I\'m afraid I don\'t understand. Could you please provide more context?',
      latestActiveDate: DateTime(2024, 10, 8),
    ),
    ChatInfo(
      botName: 'BotC06G',
      botId: 'botc06g',
      mainContent: 'Ajq',
      latestMessage: 'I apologize, but I do not understand the input "Ajq".',
      latestActiveDate: DateTime(2024, 10, 7),
    ),
    ChatInfo(
      botName: 'Assistant',
      botId: 'assistant',
      mainContent: 'Laughing',
      latestMessage: 'Hey there! What\'s on your mind?',
      latestActiveDate: DateTime(2024, 10, 7),
    ),
    ChatInfo(
      botName: 'BotC06G',
      botId: 'botc06g',
      mainContent: 'Gibberish',
      latestMessage:
          'I apologize, but I do not understand what you mean by "Rhrhrbrb"...',
      latestActiveDate: DateTime(2024, 10, 7),
    ),
    ChatInfo(
      botName: 'GPT-4o',
      botId: 'gpt-4o',
      mainContent: 'Tìm ánh sáng',
      latestMessage:
          'Tôi xin lỗi vì sự nhầm lẫn trước đó. Dưới đây là các liên kết đến...',
      latestActiveDate: DateTime(2024, 7, 13),
    ),
    ChatInfo(
      botName: 'GPT-4o',
      botId: 'gpt-4o',
      mainContent: 'Bayesian Inference',
      latestMessage:
          'Dưới đây là mã Python để thực hiện các bước trên trong Jupyter...',
      latestActiveDate: DateTime(2024, 5, 27),
    ),
    ChatInfo(
      botName: 'Gemini',
      botId: 'gemini',
      mainContent: 'Bayesian Inference',
      latestMessage: '```python...',
      latestActiveDate: DateTime(2024, 5, 27),
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
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "All chats",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        actions: const [
          RemainToken(),
        ],
      ),
      body: ListView.separated(
        itemCount: chatMessages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: ListTile(
              //Navigate to thread chat.
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatScreen()));
              },
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  chatMessages[index].botName[0], // First letter of the botName
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatMessages[index].botName,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    chatMessages[index].mainContent,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    chatMessages[index].latestMessage,
                    maxLines: 1, // Truncate if too long
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
              trailing: Column(
                children: [
                  Text(
                    formatDate(chatMessages[index].latestActiveDate),
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
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirm '),
          content: const Text('Are you sure you want to delete this chat?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the deletion logic here
                Navigator.of(context).pop(); // Dismiss the dialog
                // You can add the logic to remove the chat from the list here
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
