import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/models/chat_info.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/providers/chat_provider.dart';
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
  late ChatProvider _chatProvider;
  late AuthProvider _authProvider;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    _fetchInitialChats();

    // Lắng nghe khi người dùng cuộn gần đến cuối danh sách để tải thêm
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _loadMoreChats();
      }
    });
  }

  Future<void> _fetchInitialChats() async {
    try {
      await _authProvider.ensureValidToken();

      await _chatProvider.fetchChats(_authProvider.accessToken!);
    } catch (e) {
      print('Error fetching chats: $e');
    }
  }

  Future<void> _loadMoreChats() async {
    if (_chatProvider.hasMore && !_chatProvider.isLoading) {
      await _chatProvider.fetchChats(
        _authProvider.accessToken!,
        loadMore: true,
      );
    }
  }

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
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading && chatProvider.chatList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.chatList.isEmpty) {
            return const Center(
              child: Text(
                'No chats available.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            itemCount: chatProvider.chatList.length +
                (chatProvider.hasMore ? 1 : 0), // Thêm item loader nếu có
            itemBuilder: (context, index) {
              if (index >= chatProvider.chatList.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final chatInfo = chatProvider.chatList[index];

              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: ChatScreen(
                        chatInfo: chatInfo,
                        isNewChat: false,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    chatInfo.mainContent[0], // First letter of the mainContent
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatInfo.mainContent,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      chatInfo.latestMessage.textMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: PopupMenuButton<String>(
                        color: Colors.white,
                        icon: const Icon(Icons.more_horiz),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showDeleteConfirmationDialog(context, chatInfo);
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
              );
            },
            separatorBuilder: (context, index) => const Divider(
              indent: 0,
              thickness: 0,
              endIndent: 0,
              height: 0,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ChatInfo chatInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog<ChatInfo>(
          title: 'Delete chat',
          content: 'Are you sure you want to delete this chat?',
          onDelete: (_) {
            _deleteChat(chatInfo);
          },
          parameter: chatInfo,
        );
      },
    );
  }

  void _deleteChat(ChatInfo chatInfo) {
    _chatProvider.clearChats(); // Clear toàn bộ dữ liệu nếu cần
  }
}
