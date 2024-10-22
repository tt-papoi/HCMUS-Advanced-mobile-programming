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
          backgroundColor: Colors.white,
          title: const Text(
            'Add Data Sources',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black45),
              ),
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
