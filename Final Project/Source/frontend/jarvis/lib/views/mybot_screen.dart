import 'package:flutter/material.dart';
import 'package:jarvis/screens/edit_bot_screen.dart';

class MyBotPage extends StatefulWidget {
  const MyBotPage({super.key});

  @override
  MyBotPageState createState() => MyBotPageState();
}

class MyBotPageState extends State<MyBotPage> {
  List<Map<String, String>> bots = [
    {"name": "Assistant", "type": "OFFICIAL", "icon": "lib/assets/logo.jpg"},
    {"name": "GPT-4o", "type": "OFFICIAL", "icon": "lib/assets/logo.jpg"},
    {"name": "BotC0G6Y4NFZZ", "type": "NEW", "icon": "lib/assets/logo.jpg"},
    {"name": "Claude-3-Sonnet", "type": "OFFICIAL", "icon": "lib/assets/logo.jpg"},
    {"name": "Web-Search", "type": "OFFICIAL", "icon": "lib/assets/logo.jpg"},
    {"name": "Claude-3.5-Sonnet", "type": "OFFICIAL", "icon": "lib/assets/logo.jpg"},
  ];

  final TextEditingController searchController = TextEditingController();

  void addBot() {
    setState(() {
      bots.add({"name": "New Bot", "type": "NEW", "icon": "lib/assets/logo.jpg"});
    });
  }

  void editBot(int index) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditBotPage(
          initialName: bots[index]["name"] ?? "",
          initialDescription: bots[index]["description"] ?? "",
        ),
      ),
    );

    if (result != null) {
      setState(() {
        bots[index]["name"] = result["name"];
        bots[index]["description"] = result["description"];
      });
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
      appBar: AppBar(
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
                setState(() {}); // Tạo lại UI dựa trên từ khóa tìm kiếm
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bots.length,
              itemBuilder: (context, index) {
                String botName = bots[index]["name"] ?? "";
                String botType = bots[index]["type"] ?? "";
                String botIconPath = bots[index]["icon"] ?? "lib/assets/default_icon.png";

                if (searchController.text.isNotEmpty &&
                    !botName.toLowerCase().contains(searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  leading: Image.asset(
                    botIconPath,
                    height: 40,
                    width: 40,
                  ),
                  title: Text(botName),
                  subtitle: botType.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: botType == 'OFFICIAL' ? Colors.blue : Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            botType,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      : null,
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'Edit') {
                        editBot(index);
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

