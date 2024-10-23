import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/create_bot_screen.dart';
import 'package:jarvis/views/create_knowledge_source_screen.dart';
import 'package:jarvis/views/edit_bot_screen.dart';

class MybotScreen extends StatefulWidget {
  const MybotScreen({super.key});

  @override
  MybotScreenState createState() => MybotScreenState();
}

class MybotScreenState extends State<MybotScreen> {
  bool isMyBotScreen = true;

  List<Bot> botList = [
    Bot(
      name: "Assistant",
      description: "AI Assistant",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
    ),
    Bot(
      name: "Supper Hero",
      description: "Supper Hero",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
    ),
    Bot(
      name: "AI Luto",
      description: "AI Luto",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
    ),
    Bot(
      name: "Turbo",
      description: "Turbo",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
    ),
  ];

  List<KnowledgeSource> knowledgeSourceList = [
    KnowledgeSource(
        id: "01",
        name: "My Job",
        description: "This knowledge source is used for my job"),
    KnowledgeSource(
        id: "01",
        name: "My house",
        description: "This knowledge source is used for my house"),
  ];

  final TextEditingController searchController = TextEditingController();

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
      botList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'My Bots',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSwitchScreen(context),
          Expanded(
            child: isMyBotScreen
                ? _buildMyBotScreen(context)
                : _buildKnowledgeSourcesScreen(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isMyBotScreen) {
            Navigator.push(context, FadeRoute(page: const CreateBotScreen()));
          } else {
            Navigator.push(
                context, FadeRoute(page: const CreateKnowledgeSourceScreen()));
          }
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSwitchScreen(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(43, 68, 137, 255),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton('My Bots', isMyBotScreen),
          _buildToggleButton('Knowledge Sources', !isMyBotScreen),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          setState(() {
            isMyBotScreen = (text == 'My Bots');
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: isActive
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildMyBotScreen(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              hintText: "Search for more bots",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black45),
              prefixIcon: const Icon(Icons.search),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
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
                  trailing: PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (String result) {
                      if (result == 'Edit') {
                        editBot(botList[index]);
                      } else if (result == 'Delete') {
                        deleteBot(index);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () {
                    editBot(botList[index]);
                  },
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
    );
  }

  Widget _buildKnowledgeSourcesScreen(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              hintText: "Search for more knowledge sources",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black45),
              prefixIcon: const Icon(Icons.search),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
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
              itemCount: knowledgeSourceList.length,
              itemBuilder: (context, index) {
                final knowledgeSource = knowledgeSourceList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  leading: const Icon(
                    Icons.file_copy_rounded,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    knowledgeSource.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    knowledgeSource.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (String result) {},
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () {
                    editBot(botList[index]);
                  },
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
    );
  }
}
