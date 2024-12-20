import 'package:flutter/material.dart';
import 'package:jarvis/models/message.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/screens/chat_screen.dart';
import 'package:jarvis/widgets/assistants_bar.dart';
import 'package:jarvis/widgets/chat_bar.dart';
import 'package:jarvis/widgets/remain_token.dart';
import 'package:jarvis/widgets/side_bar.dart';
import 'package:jarvis/widgets/suggestion_prompt.dart';

class Suggestion {
  final String title;
  final String subtitle;

  Suggestion({required this.title, required this.subtitle});
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Define a GlobalKey for BotBar
  final GlobalKey<AssistantBarState> assistantBarKey =
      GlobalKey<AssistantBarState>();

  // ValueNotifier to manage BotBar visibility
  final ValueNotifier<bool> _isBotBarVisible = ValueNotifier<bool>(true);

  // List of suggestions
  final List<Suggestion> suggestions = [
    Suggestion(title: 'Write an email', subtitle: 'to apply for a job'),
    Suggestion(title: 'Practice for interviews', subtitle: 'for success'),
    Suggestion(title: 'Translate sentences', subtitle: 'instantly'),
    Suggestion(title: 'Explain an issue', subtitle: 'why the earth is round'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/icons/logo.png",
              height: 25,
              width: 25,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "Jarvis",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: const [
          RemainToken(),
        ],
      ),
      drawer: const SideBar(),
      body: Column(
        children: [
          // Expanded widget for the top section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "lib/assets/icons/hand.png",
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    "Hi, there!",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "I'm Jarvis, your personal AI assistant. \nYou can select a suggestion from below or tell me what you need.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // ListView for suggestions
                  Expanded(
                    child: ListView.separated(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        return SuggestionPrompt(
                          title: suggestion.title,
                          subtitle: suggestion.subtitle,
                          onTap: () {
                            Message chatMessage = Message(
                              content:
                                  "${suggestion.title} ${suggestion.subtitle}",
                              role: Role.user,
                              file: null,
                            );
                            _startNewChat(context, chatMessage);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isBotBarVisible,
            builder: (context, isVisible, child) {
              return isVisible
                  ? AssistantBar(key: assistantBarKey)
                  : Container();
            },
          ),
          ChatBar(
            hintMessage: 'Start a new chat',
            onSendMessage: (Message message) {
              _startNewChat(context, message);
            },
            onSlashTyped: (bool isSlashTyped) {
              _isBotBarVisible.value = !isSlashTyped;
            },
          ),
        ],
      ),
    );
  }

  void _startNewChat(BuildContext context, Message message) async {
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      FadeRoute(page: ChatScreen(isNewChat: true, newMessage: message)),
    );
  }
}
