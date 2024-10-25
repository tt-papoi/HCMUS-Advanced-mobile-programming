import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/screens/create_bot_screen.dart';
import 'package:jarvis/screens/create_knowledge_source_screen.dart';
import 'package:jarvis/screens/edit_bot_screen.dart';
import 'package:jarvis/screens/edit_knowledge_source.dart';

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
      knowledgeSources: [],
    ),
    Bot(
      name: "Supper Hero",
      description: "Supper Hero",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
      knowledgeSources: [],
    ),
    Bot(
      name: "AI Luto",
      description: "AI Luto",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
      knowledgeSources: [],
    ),
    Bot(
      name: "Turbo",
      description: "Turbo",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
      knowledgeSources: [],
    ),
  ];

  List<KnowledgeSource> knowledgeSourceList = [
    KnowledgeSource(
        id: "01",
        name: "My Job",
        description: "This knowledge source is used for my job"),
    KnowledgeSource(
        id: "02",
        name: "My house",
        description: "This knowledge source is used for my house"),
  ];

  final TextEditingController searchController = TextEditingController();
  List<Bot> filteredBotList = []; // List to store filtered bots

  @override
  void initState() {
    super.initState();
    filteredBotList = botList; // Initialize the filtered list to show all bots
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterBots(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBotList = botList;
      } else {
        filteredBotList = botList
            .where(
                (bot) => bot.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
        onPressed: () async {
          if (isMyBotScreen) {
            final newBot = await Navigator.push(
              context,
              FadeRoute(page: const CreateBotScreen()),
            );

            if (newBot != null) {
              setState(() {
                botList.add(newBot);
                filteredBotList = botList;
              });
            }
          } else {
            final newKnowledgeSource = await Navigator.push(
              context,
              FadeRoute(page: const CreateKnowledgeSourceScreen()),
            );

            if (newKnowledgeSource != null) {
              setState(() {
                knowledgeSourceList.add(newKnowledgeSource);
              });
            }
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyBotScreen(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              hintText: "Search for more bots",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black45),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black45,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
            ),
            onChanged: _filterBots,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredBotList.length,
              itemBuilder: (context, index) {
                final bot = filteredBotList[index];
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
                          borderRadius: BorderRadius.circular(5),
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

  void editBot(Bot bot) async {
    final result = await Navigator.of(context).push(FadeRoute(
      page: EditBotScreen(
        bot: bot,
        knowledgeSourceList: knowledgeSourceList,
      ),
    ));
    if (result != null) {
      setState(() {});
    }
  }

  void deleteBot(int index) {
    setState(() {
      botList.removeAt(index);
      filteredBotList = botList;
    });
  }

  void editKnowledgeSource(KnowledgeSource knowledgesource) async {
    final result = await Navigator.of(context).push(FadeRoute(
      page: EditKnowledgeSourceScreen(
        knowledgeSource: knowledgesource,
      ),
    ));
    if (result != null) {
      setState(() {});
    }
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
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black45,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
            ),
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
                    editKnowledgeSource(knowledgeSourceList[index]);
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
