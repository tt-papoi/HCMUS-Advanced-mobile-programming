import 'package:flutter/material.dart';

class EditBotPage extends StatefulWidget {
  final String initialName;
  final String initialBaseBot;
  final String initialPrompt;
  final String initialGreeting;
  final List<String> initialDataSources;

  const EditBotPage({
    super.key,
    required this.initialName,
    required this.initialBaseBot,
    required this.initialPrompt,
    required this.initialGreeting,
    this.initialDataSources = const [],
  });

  @override
  EditBotPageState createState() => EditBotPageState();
}

class EditBotPageState extends State<EditBotPage> {
  late TextEditingController nameController;
  late TextEditingController baseBotController;
  late TextEditingController promptController;
  late TextEditingController greetingController;
  late List<String> dataSources;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    baseBotController = TextEditingController(text: widget.initialBaseBot);
    promptController = TextEditingController(text: widget.initialPrompt);
    greetingController = TextEditingController(text: widget.initialGreeting);
    dataSources = List<String>.from(widget.initialDataSources);
  }

  @override
  void dispose() {
    nameController.dispose();
    baseBotController.dispose();
    promptController.dispose();
    greetingController.dispose();
    super.dispose();
  }

  void _showKnowledgeSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Data Sources'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Local files'),
                onTap: () {
                  // Handle local file selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Website'),
                onTap: () {
                  // Handle website selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('GitHub repositories'),
                onTap: () {
                  // Handle GitHub repository selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Google Drive'),
                onTap: () {
                  // Handle Google Drive selection
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Bot'),
        actions: [
          TextButton(
            onPressed: () {
              // Save edited bot
              Navigator.of(context).pop({
                'name': nameController.text,
                'baseBot': baseBotController.text,
                'prompt': promptController.text,
                'greeting': greetingController.text,
                'dataSources': dataSources,
              });
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Bot Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: baseBotController,
              decoration: const InputDecoration(
                labelText: 'Base Bot',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: promptController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Prompt',
                border: OutlineInputBorder(),
                hintText:
                    'Describe bot behavior and response. Be clear and specific.',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Knowledge Base',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Provide custom knowledge that your bot will access to inform its responses.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showKnowledgeSourceDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add knowledge source'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Greeting Message',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The bot will send this message at the beginning of every conversation.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: greetingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText:
                    'Hi there! I\'m your travel assistant. How can I help you plan your next adventure today?',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
