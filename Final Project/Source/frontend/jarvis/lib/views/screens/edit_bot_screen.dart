import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/utils/dialog_utils.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/dialogs/confirm_delete_dialog.dart';
import 'package:jarvis/views/screens/create_knowledge_source_screen.dart';
import 'package:jarvis/widgets/custom_search_bar.dart';

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
  KnowledgeSource? selectedSource;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.bot.name);
    promptController = TextEditingController(text: widget.bot.prompt);
    dataSources = widget.bot.knowledgeSources ?? [];
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
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text(
                'Add Knowledge Source',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row for Search bar and Create button
                    Row(
                      children: [
                        Expanded(
                          child: CustomSearchBar(
                            hintText: "Search",
                            onChanged: (String value) {
                              setStateDialog(() {
                                searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                            width: 10), // Spacing between search and button
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: const CreateKnowledgeSourceScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.create_new_folder_outlined,
                              color: Colors.black45,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // List of knowledge sources (filtered by search)
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.knowledgeSourceList.length,
                        itemBuilder: (context, index) {
                          final knowledgeSource =
                              widget.knowledgeSourceList[index];
                          final isSelected = selectedSource == knowledgeSource;

                          // Filter knowledge sources based on search query
                          if (searchQuery.isNotEmpty &&
                              !knowledgeSource.name
                                  .toLowerCase()
                                  .contains(searchQuery)) {
                            return const SizedBox
                                .shrink(); // Hide if not matching search
                          }

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected
                                  ? Colors.blueAccent
                                  : const Color.fromARGB(10, 0, 0, 0),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              leading: Icon(
                                Icons.file_copy_rounded,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.blueAccent,
                              ),
                              title: Text(
                                knowledgeSource.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                knowledgeSource.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                              onTap: () {
                                setStateDialog(() {
                                  if (isSelected) {
                                    selectedSource = null;
                                  } else {
                                    selectedSource = knowledgeSource;
                                  }
                                });
                              },
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      if (!dataSources.contains(selectedSource)) {
                        dataSources.add(selectedSource!);
                      }
                    });
                    selectedSource = null;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog<KnowledgeSource>(
          title: 'Delete knowledge source',
          content: 'Are you sure you want to delete this knowledge source?',
          onDelete: (knowledgeSource) {
            setState(() {
              dataSources.removeAt(index);
            });
          },
          parameter: dataSources[index],
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
              maxLines: 1,
              controller: nameController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: '4–20 characters',
                filled: true,
                fillColor: const Color.fromARGB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black26, width: 1.0),
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
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: 'Describe bot behavior and response',
                filled: true,
                fillColor: const Color.fromARGB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black26, width: 1.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Knowledge sources',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
                InkWell(
                    onTap: () {
                      _showKnowledgeSourceDialog();
                    },
                    child: const Icon(Icons.add_box_rounded,
                        color: Colors.blueAccent, size: 25)),
              ],
            ),
            const SizedBox(height: 8),

            // Knowledge sources description
            const Text(
              'Provide custom knowledge that your bot will access to inform its responses.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              itemCount: dataSources.length,
              itemBuilder: (context, index) {
                final knowledgeSource = dataSources[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: const Color.fromARGB(15, 0, 0, 0),
                  onTap: () => {},
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
                      PopupMenuItem(
                        value: 'Delete',
                        child: const Text('Delete'),
                        onTap: () {
                          setState(() {
                            _showDeleteConfirmationDialog(context, index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
            ),

            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _saveBot,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                child: const Center(
                  child: Text(
                    'Save Bot',
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

  void _saveBot() {
    // Simple form validation
    if (nameController.text.isEmpty ||
        nameController.text.length < 4 ||
        nameController.text.length > 20) {
      DialogUtils.showErrorDialog(
          context, "Name must be between 4 and 20 characters.");
      return;
    }
    if (promptController.text.isEmpty) {
      DialogUtils.showErrorDialog(context, "Prompt is required.");
      return;
    }
    setState(() {
      widget.bot.knowledgeSources = dataSources;
    });
    Navigator.of(context).pop(dataSources);
  }
}
