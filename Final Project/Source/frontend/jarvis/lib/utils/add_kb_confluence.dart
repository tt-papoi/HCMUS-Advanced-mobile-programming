import 'package:flutter/material.dart';

class ConfluenceDialog extends StatefulWidget {
  final Function(String name, String url, String username, String token)
      onConnect;

  const ConfluenceDialog({super.key, required this.onConnect});

  @override
  ConfluenceDialogState createState() => ConfluenceDialogState();
}

class ConfluenceDialogState extends State<ConfluenceDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.link),
          SizedBox(width: 8),
          Text('Confluence'),
        ],
      ),
      content: SingleChildScrollView(
        // Add this to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter a name for this connection',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Wiki Page URL',
                hintText: 'Enter the Confluence page URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Confluence Username',
                hintText: 'Enter your Confluence username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tokenController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confluence Access Token',
                hintText: 'Enter your Confluence access token',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                urlController.text.isNotEmpty &&
                usernameController.text.isNotEmpty &&
                tokenController.text.isNotEmpty) {
              widget.onConnect(
                nameController.text,
                urlController.text,
                usernameController.text,
                tokenController.text,
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connected successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: const Text('Connect'),
        ),
      ],
    );
  }
}
