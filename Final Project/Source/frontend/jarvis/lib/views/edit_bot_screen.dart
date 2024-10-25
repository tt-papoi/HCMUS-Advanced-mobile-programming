import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/create_knowledge_source_screen.dart';

class EditBotScreen extends StatefulWidget {
  final Bot bot;
  final List<KnowledgeSource> knowledgeSourceList;

  const EditBotScreen({
    super.key,
    required this.bot,
    required this.knowledgeSourceList,
  });

  @override
  State<EditBotScreen> createState() => _EditBotScreenState();
}

class _EditBotScreenState extends State<EditBotScreen> {
  late TextEditingController nameController;
  late TextEditingController promptController;
  late List<KnowledgeSource> dataSources;
  Set<KnowledgeSource> selectedSources = {};

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.bot.name);
    promptController = TextEditingController(text: widget.bot.prompt);
    dataSources = [];
  }

  @override
  void dispose() {
    nameController.dispose();
    promptController.dispose();
    super.dispose();
  }

  void _showKnowledgeSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            String searchQuery = ''; // Track search input

            return AlertDialog(
              title: const Text('Add Knowledge Source'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row for Search bar and Create button
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Search for more sources",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black45),
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 1.0),
                            ),
                          ),
                          onChanged: (value) {
                            setStateDialog(() {
                              searchQuery = value
                                  .toLowerCase(); // Update the search query
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Spacing between search and button
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.blueAccent,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                FadeRoute(
                                    page: const CreateKnowledgeSourceScreen()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 16), // Add spacing after search and create button

                  // List of knowledge sources (filtered by search)
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.knowledgeSourceList.length,
                        itemBuilder: (context, index) {
                          final knowledgeSource =
                              widget.knowledgeSourceList[index];
                          final isSelected =
                              selectedSources.contains(knowledgeSource);

                          // Filter knowledge sources based on search query
                          if (searchQuery.isNotEmpty &&
                              !knowledgeSource.name
                                  .toLowerCase()
                                  .contains(searchQuery)) {
                            return const SizedBox
                                .shrink(); // Hide if not matching search
                          }

                          return ListTile(
                            title: Text(knowledgeSource.name),
                            tileColor: isSelected
                                ? Colors.blueAccent.withOpacity(0.8)
                                : null,
                            selectedTileColor:
                                Colors.blueAccent.withOpacity(0.8),
                            onTap: () {
                              setStateDialog(() {
                                if (isSelected) {
                                  selectedSources.remove(knowledgeSource);
                                } else {
                                  selectedSources.add(knowledgeSource);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                if (selectedSources.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (var source in selectedSources) {
                          if (!dataSources.contains(source)) {
                            dataSources.add(source);
                          }
                        }
                      });
                      selectedSources.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add Selected'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "Edit bot",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Name with asterisk
            const Text.rich(
              TextSpan(
                text: 'Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              minLines: 1,
              maxLines: null,
              controller: nameController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText:
                    '4–20 characters: letters, numbers, dashes, periods, underscores.',
                filled: true,
                fillColor: const Color.fromARGB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1.0),
                ),
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 16),
            // Prompt with asterisk
            const Text.rich(
              TextSpan(
                text: 'Prompt',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: promptController,
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText:
                    'Describe bot behavior and response. Be clear and specific.',
                filled: true,
                fillColor: const Color.fromARGB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1.0),
                ),
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Knowledge sources',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Provide custom knowledge that your bot will access to inform its responses.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: dataSources.length,
              itemBuilder: (context, index) {
                final knowledgeSource = dataSources[index];
                return ListTile(
                  leading: const Icon(
                    Icons.file_copy_rounded,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    knowledgeSource.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description: ${knowledgeSource.description}",
                        selectionColor: Colors.black87,
                      ), // Hiển thị thêm mô tả nếu có
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (String result) {
                      if (result == 'Delete') {
                        setState(() {
                          dataSources.removeAt(index);
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text(
                          'Delete',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                _showKnowledgeSourceDialog();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black54, width: 1.0)),
                child: const Center(
                  child: Text(
                    'Add knowledge source',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Display selected knowledge sources

            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Logic to create bot
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                child: const Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
