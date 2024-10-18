import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/create_bot_screen.dart';
import 'package:jarvis/views/edit_bot_screen.dart';

class MybotScreen extends StatefulWidget {
  const MybotScreen({super.key});

  @override
  MybotScreenState createState() => MybotScreenState();
}

class MybotScreenState extends State<MybotScreen> {
  List<Bot> bots = [
    Bot(
      name: "Assistant",
      description: "AI Assistant",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
    ),
    Bot(
      name: "GPT-4.0",
      description: "GPT-4.0",
      imagePath: 'lib/assets/icons/chatgpt_icon.png',
      id: '',
      botType: BotType.offical,
    ),
    Bot(
      name: "GPT-3.5",
      description: "GPT-3.5",
      imagePath: 'lib/assets/icons/chatgpt_icon.png',
      id: '',
      botType: BotType.offical,
    ),
    Bot(
      name: "GPT-4.0-Turbo",
      description: "GPT-4.0-Turbo",
      imagePath: 'lib/assets/icons/chatgpt_icon.png',
      id: '',
      botType: BotType.offical,
    ),
  ];

  final TextEditingController searchController = TextEditingController();

  void addBot() async {
    final result = await Navigator.of(context)
        .push(FadeRoute(page: const CreateBotScreen()));

    if (result != null) {
      setState(() {
        //bots.add();
      });
    }
  }

  void editBot(Bot bot) async {
    final result = await Navigator.of(context).push(FadeRoute(
        page: EditBotScreen(
      bot: bot,
    )));
    if (result != null) {
      setState(() {});
    }
  }

  void deleteBot(int index) {
    setState(() {
      bots.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('My Bots'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for more bots',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Update UI based on search input
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bots.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    child: Image.asset(
                      bots[index].imagePath,
                    ),
                  ),
                  title: Text(bots[index].name),
                  trailing: PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (String result) {
                      if (result == 'Edit') {
                        editBot(bots[index]);
                      } else if (result == 'Delete') {
                        deleteBot(index);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBot,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }
}
