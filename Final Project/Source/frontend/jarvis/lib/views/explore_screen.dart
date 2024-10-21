import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<Bot> botList = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for more bots",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1.0),
                ),
              ),
              onChanged: (value) {
                // You can implement filtering logic here based on the value
              },
            ),
            Expanded(
              child: ListView.separated(
                itemCount: botList.length,
                itemBuilder: (context, index) {
                  final bot = botList[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    leading:
                        Image.asset(bot.imagePath, width: 45.0, height: 45.0),
                    title: Text(
                      bot.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                          ),
                          child: Text(
                            bot.botType == BotType.offical
                                ? 'OFFICIAL'
                                : "MY BOT",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  indent: 0,
                  thickness: 0,
                  endIndent: 0,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
