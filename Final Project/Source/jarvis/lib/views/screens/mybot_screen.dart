import 'package:flutter/material.dart';

import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/models/my_bot.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/screens/create_bot_screen.dart';
import 'package:jarvis/views/screens/create_knowledge_source_screen.dart';
import 'package:jarvis/views/screens/edit_bot_screen.dart';
import 'package:jarvis/views/screens/edit_knowledge_source_screen.dart';
import 'package:jarvis/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';

class MybotScreen extends StatefulWidget {
  const MybotScreen({super.key});

  @override
  MybotScreenState createState() => MybotScreenState();
}

class MybotScreenState extends State<MybotScreen> {
  bool isMyBotScreen = true;

  List<Assistant> botList = [
    Assistant(
      name: "Assistant",
      description: "AI Assistant",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
      prompt: 'You are my assistant',
      knowledgeSources: [],
    ),
    Assistant(
      name: "Supper Hero",
      description: "Supper Hero",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
      prompt: 'You are my hero',
      knowledgeSources: [],
    ),
    Assistant(
      name: "AI Luto",
      description: "AI Luto",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
      prompt: 'You are my Assistant of Luto Project',
      knowledgeSources: [],
    ),
    Assistant(
      name: "Turbo",
      description: "Turbo",
      imagePath: 'lib/assets/icons/robot.png',
      id: '',
      botType: BotType.createdBot,
      prompt: 'Assistant for Turbo Project',
      knowledgeSources: [],
    ),
  ];

  List<KnowledgeSource> knowledgeSourceList = [];

  List<Assistant> filteredBotList = []; // List to store filtered bots

  @override
  @override
  void initState() {
    super.initState();

    final kbProvider =
        Provider.of<KnowledgeBaseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Future.microtask(() async {
      await kbProvider.fetchKnowledgeBases(authProvider);

      if (!mounted) return;
      // Cập nhật danh sách knowledgeSourceList
      setState(() {
        knowledgeSourceList = kbProvider.knowledgeSources;
      });
    });

    // Khởi tạo danh sách lọc
    filteredBotList = botList;
  }

  @override
  void dispose() {
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
                : Consumer<KnowledgeBaseProvider>(
                    builder: (context, kbProvider, child) {
                      knowledgeSourceList = kbProvider.knowledgeSources;
                      return _buildKnowledgeSourcesScreen(context);
                    },
                  ),
          ),
          const SizedBox(height: 60),
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
          CustomSearchBar(hintText: "Search", onChanged: _filterBots),
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
                  subtitle: Text(bot.prompt ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
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

  void editBot(Assistant bot) async {
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
    if (!mounted) return;
    if (result != null) {
      final kbProvider =
          Provider.of<KnowledgeBaseProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        await kbProvider.updateKnowledgeBase(
          id: result.id,
          knowledgeName: result.knowledgeName,
          description: result.description,
          authProvider: authProvider,
        );
      } catch (e) {
        // Xử lý lỗi
        throw Exception('Error updating Knowledge Base: $e');
      }
    }
  }

  Future<void> deleteKnowledgeSource(int index) async {
    try {
      final kbProvider =
          Provider.of<KnowledgeBaseProvider>(context, listen: false);
      await kbProvider.deleteKnowledgeBase(
        id: knowledgeSourceList[index].id,
        authProvider: Provider.of<AuthProvider>(context, listen: false),
      );

      setState(() {
        knowledgeSourceList.removeAt(index); // Xóa khỏi danh sách cục bộ
      });

      if (!mounted) return; // Kiểm tra lại trước khi hiển thị Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge Source deleted successfully')),
      );
    } catch (error) {
      if (!mounted) {
        return; // Kiểm tra nếu widget đã bị hủy trước khi hiển thị Snackbar
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Knowledge Source: $error')),
      );
    }
  }

  Widget _buildKnowledgeSourcesScreen(BuildContext context) {
    final kbProvider = Provider.of<KnowledgeBaseProvider>(context);
    if (kbProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (knowledgeSourceList.isEmpty) {
      return const Center(
        child: Text(
          'No Knowledge Sources available.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          CustomSearchBar(hintText: "Search", onChanged: (String value) {}),
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
                    knowledgeSource.knowledgeName,
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
                      PopupMenuItem(
                        value: 'Delete',
                        child: const Text('Delete'),
                        onTap: () => deleteKnowledgeSource(index),
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
