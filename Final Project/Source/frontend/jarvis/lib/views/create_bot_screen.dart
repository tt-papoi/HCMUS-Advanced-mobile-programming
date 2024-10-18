import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateBotScreen extends StatefulWidget {
  const CreateBotScreen({super.key});

  @override
  CreateBotScreenState createState() => CreateBotScreenState();
}

class CreateBotScreenState extends State<CreateBotScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController promptController = TextEditingController();
  final TextEditingController greetingController = TextEditingController();
  String? selectedBaseBot;
  final List<String> baseBots = ['Claude-3-Haiku', 'Other'];
  Uint8List? imageData;

  @override
  void dispose() {
    nameController.dispose();
    promptController.dispose();
    greetingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List data = await image.readAsBytes();
      setState(() {
        imageData = data;
      });
    }
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
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Local files'),
                onTap: () {
                  // Handle local file selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.web),
                title: const Text('Website'),
                onTap: () {
                  // Handle website selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Confluence'),
                onTap: () {
                  // Handle Confluence selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Google Drive'),
                onTap: () {
                  // Handle Google Drive selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Slack'),
                onTap: () {
                  // Handle Slack selection
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Create a Bot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    imageData != null ? MemoryImage(imageData!) : null,
                child: imageData == null
                    ? IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: _pickImage,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              minLines: 1,
              maxLines: null,
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText:
                    '4–20 characters: letters, numbers, dashes, periods, underscores.',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Base bot',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: selectedBaseBot,
              items: baseBots.map((bot) {
                return DropdownMenuItem(
                  value: bot,
                  child: Text(bot),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBaseBot = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Prompt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: promptController,
              maxLines: 3,
              decoration: const InputDecoration(
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
                elevation: 0, // No shadow effect
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
              minLines: 1,
              maxLines: null,
              controller: greetingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText:
                    'Hi there! I\'m your travel assistant. How can I help you plan your next adventure today?',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logic to create bot
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blueAccent,
                elevation: 0,
              ),
              child: const Text(
                'Create Bot',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
