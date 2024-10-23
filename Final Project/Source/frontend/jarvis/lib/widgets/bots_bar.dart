import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';

class BotBar extends StatefulWidget {
  const BotBar({super.key});

  @override
  State<BotBar> createState() => BotBarState();
}

class BotBarState extends State<BotBar> {
  Bot? selectedBot;

  // Original list of bots
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

  // List for displaying bots
  List<Bot> displayedBots = [];

  Bot? get getSelectedBot => selectedBot;

  @override
  void initState() {
    super.initState();
    // Initialize the displayed bots with the first three bots from the original list
    displayedBots = List.from(botList.take(3));
    if (displayedBots.isNotEmpty) {
      selectedBot = displayedBots.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < displayedBots.length; i++) ...[
            _buildNavItem(
              context: context,
              bot: displayedBots[i],
              isSelected: selectedBot == displayedBots[i],
              onTap: () {
                setState(() {
                  selectedBot = displayedBots[i];
                });
              },
            ),
            // add space between 2 bots
            if (i < displayedBots.length - 1) const SizedBox(width: 5.0),
          ],

          const SizedBox(width: 5.0),
          // Display the "More" option
          _buildNavItem(
            context: context,
            bot: Bot(
              name: 'More',
              description: 'More options',
              imagePath: 'lib/assets/icons/category.png',
              id: '',
              botType: BotType.offical,
            ),
            isSelected: false,
            onTap: () {
              _showBotList(context);
            },
          ),
        ],
      ),
    );
  }

  void _showBotList(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
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
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
                      onTap: () {
                        setState(() {
                          selectedBot = bot;
                          // Check if the selected bot is already in the displayed list
                          if (!displayedBots.contains(selectedBot)) {
                            // Move the selected bot to the front of the displayed list
                            displayedBots.insert(0, selectedBot!);
                            // Ensure displayedBots contains only three bots
                            if (displayedBots.length > 3) {
                              displayedBots.removeLast();
                            }
                          }
                        });
                        Navigator.pop(context);
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
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required Bot bot,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : Colors.transparent, // Change background color
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Image.asset(bot.imagePath, width: 24.0, height: 24.0),
            const SizedBox(width: 8.0),
            Text(
              bot.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : Colors.black, // Change text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
