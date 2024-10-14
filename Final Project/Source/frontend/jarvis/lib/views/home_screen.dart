import 'package:flutter/material.dart';
import 'package:jarvis/widgets/bots_bar.dart';
import 'package:jarvis/widgets/chat_bar.dart';
import 'package:jarvis/widgets/remain_token.dart';
import 'package:jarvis/widgets/side_bar.dart';
import 'package:jarvis/widgets/suggestion_prompt.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      drawer: const SideBar(),
      body: Column(
        children: [
          // This Expanded widget is for the top section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting text
                  const Text(
                    'Hello!',
                    style: TextStyle(
                      fontSize: 24,
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
                  // Fixed 4 suggestions without scrolling
                  Expanded(
                    child: ListView(
                      children: [
                        SuggestionPrompt(
                          title: 'Write an email',
                          subtitle: 'to apply for a job',
                          onTap: () {
                            // Handle what happens when this suggestion is tapped
                          },
                        ),
                        const SizedBox(height: 16.0),
                        SuggestionPrompt(
                          title: 'Practice for interviews',
                          subtitle: 'for success',
                          onTap: () {
                            // Handle what happens when this suggestion is tapped
                          },
                        ),
                        const SizedBox(height: 16.0),
                        SuggestionPrompt(
                          title: 'Translate sentences',
                          subtitle: 'instantly',
                          onTap: () {
                            // Handle what happens when this suggestion is tapped
                          },
                        ),
                        const SizedBox(height: 16.0),
                        SuggestionPrompt(
                          title: 'Explain an issue',
                          subtitle: 'why the earth is round',
                          onTap: () {
                            // Handle what happens when this suggestion is tapped
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BotBar(),
          const ChatBar(),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
