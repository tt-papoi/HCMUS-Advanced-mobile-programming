import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/models/conversation.dart';
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
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _fetchInitialChats();
    super.initState();
  }

  Future<void> _fetchInitialChats() async {
    try {
      await _authProvider.refreshAccessToken();

      _chatProvider.conversationList.clear();
      _chatProvider.isLoading = true;
      _chatProvider.fetchChats(_authProvider.accessToken!, limit: 20);
    } catch (e) {
      throw Exception('Error in fetchInitialChats: $e');
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatProvider.clearChats();
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
          if (chatProvider.isLoading && chatProvider.conversationList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.conversationList.isEmpty) {
            return const Center(
              child: Text(
                'No chats available.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            itemCount: chatProvider.conversationList.length +
                (chatProvider.hasMore ? 1 : 0), // Thêm item loader nếu có
            itemBuilder: (context, index) {
              if (index >= chatProvider.conversationList.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final conversation = chatProvider.conversationList[index];

              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: ChatScreen(
                        conversation: conversation,
                        isNewChat: false,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    conversation.title[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      conversation.messages!.isNotEmpty
                          ? conversation.messages!.last.content
                          : 'No messages',
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
                    Text(
                      formatDate(conversation.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Expanded(
                      child: PopupMenuButton<String>(
                        color: Colors.white,
                        icon: const Icon(Icons.more_horiz),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showDeleteConfirmationDialog(
                                context, conversation);
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
              height: 10,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Conversation chatInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog<Conversation>(
          title: 'Delete chat',
          content: 'Are you sure you want to delete this chat?',
          onDelete: (_) {},
          parameter: chatInfo,
        );
      },
    );
  }
}
