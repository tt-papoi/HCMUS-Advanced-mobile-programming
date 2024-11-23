import 'package:flutter/material.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/providers/chat_provider.dart';

import 'package:jarvis/utils/constants.dart';
import 'package:provider/provider.dart';

class AssistantBar extends StatefulWidget {
  const AssistantBar({super.key});

  @override
  State<AssistantBar> createState() => AssistantBarState();
}

class AssistantBarState extends State<AssistantBar> {
  // Original list of bots
  final List<Assistant> assistantList = ProjectConstants.defaultAssistants;

  // List for displaying bots
  List<Assistant> displayedAssistants = [];

  @override
  void initState() {
    super.initState();
    // Initialize the displayed bots with the first three bots from the original list
    displayedAssistants = List.from(assistantList.take(3));
    if (displayedAssistants.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).selectedAssistant =
          displayedAssistants.first;
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
          for (var i = 0; i < displayedAssistants.length; i++) ...[
            _buildNavItem(
              context: context,
              bot: displayedAssistants[i],
              isSelected: Provider.of<ChatProvider>(context, listen: false)
                      .selectedAssistant ==
                  displayedAssistants[i],
              onTap: () {
                setState(() {
                  Provider.of<ChatProvider>(context, listen: false)
                      .selectedAssistant = displayedAssistants[i];
                });
              },
            ),
            // add space between 2 bots
            if (i < displayedAssistants.length - 1) const SizedBox(width: 5.0),
          ],

          const SizedBox(width: 5.0),
          // Display the "More" option
          _buildNavItem(
            context: context,
            bot: Assistant(
              name: 'More',
              model: "dify",
              imagePath: 'lib/assets/icons/category.png',
              id: '',
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
              Expanded(
                child: ListView.separated(
                  itemCount: assistantList.length,
                  itemBuilder: (context, index) {
                    final assistant = assistantList[index];
                    return ListTile(
                      leading: Image.asset(
                          assistant.imagePath ?? 'lib/assets/icons/robot.png',
                          width: 30.0,
                          height: 30.0),
                      title: Text(
                        assistant.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Provider.of<ChatProvider>(context, listen: false)
                              .selectedAssistant = assistant;
                          Provider.of<ChatProvider>(context, listen: false)
                              .selectedAssistant = assistant;
                          // Check if the selected bot is already in the displayed list
                          if (!displayedAssistants.contains(
                              Provider.of<ChatProvider>(context, listen: false)
                                  .selectedAssistant)) {
                            // Move the selected bot to the front of the displayed list
                            displayedAssistants.insert(
                                0,
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .selectedAssistant);
                            // Ensure displayedBots contains only three bots
                            if (displayedAssistants.length > 3) {
                              displayedAssistants.removeLast();
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
    required Assistant bot,
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
              : const Color.fromARGB(15, 0, 0, 0), // Change background color
          border: isSelected
              ? null
              : Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Image.asset(bot.imagePath ?? 'lib/assets/icons/robot.png',
                width: 24.0, height: 24.0),
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
