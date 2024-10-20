// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/utils/add_kb_confluence.dart';
import 'package:jarvis/utils/add_kb_gg_drive.dart';
import 'package:jarvis/utils/add_kb_local_file.dart';
import 'package:jarvis/utils/add_kb_slack.dart';
import 'package:jarvis/utils/add_kb_web.dart';

class EditBotScreen extends StatefulWidget {
  final Bot bot;
  const EditBotScreen({
    super.key,
    required this.bot,
  });

  @override
  State<EditBotScreen> createState() => _EditBotScreenState();
}

class _EditBotScreenState extends State<EditBotScreen> {
  late TextEditingController nameController;
  late TextEditingController promptController;
  late List<String> dataSources;

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

  // Dialog to add a website knowledge source
  void _showWebsiteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WebsiteDialog(
          onConnect: (name, url) {
            setState(() {
              dataSources.add('$name ($url)');
            });
          },
        );
      },
    );
  }
  // Dialog to add a local file as a knowledge source

  void _showLocalFileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocalFileDialog(
          onConnect: (name, file) {
            setState(() {
              dataSources.add('Local file: $name (File: ${file.name})');
            });
          },
        );
      },
    );
  }

  void _showGoogleDriveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GoogleDriveDialog(
          onConnect: (name, fileName) {
            setState(() {
              dataSources.add('Google Drive: $name (File: $fileName)');
            });
          },
        );
      },
    );
  }

  void _showConfluenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfluenceDialog(
          onConnect: (name, url, username, token) {
            setState(() {
              dataSources
                  .add('Confluence: $name (URL: $url, Username: $username)');
            });
          },
        );
      },
    );
  }

  void _showSlackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SlackDialog(
          onConnect: (name, workspace, token) {
            setState(() {
              dataSources.add('Slack: $name (Workspace: $workspace)');
            });
          },
        );
      },
    );
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
                  Navigator.of(context).pop();
                  _showLocalFileDialog(); // Show local file dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Website'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showWebsiteDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Confluence'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showConfluenceDialog();
                  // Handle Confluence selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_folder_upload),
                title: const Text('Google Drive'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showGoogleDriveDialog(); // Show Google Drive dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Slack'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showSlackDialog();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return; // Guard with mounted check
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
        title: Text(widget.bot.name),
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
              controller: promptController,
              minLines: 3,
              maxLines: null,
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
          ],
        ),
      ),
    );
  }
}
