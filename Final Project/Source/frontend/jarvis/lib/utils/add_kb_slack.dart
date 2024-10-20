import 'package:flutter/material.dart';

class SlackDialog extends StatefulWidget {
  final Function(String name, String workspace, String token) onConnect;

  const SlackDialog({super.key, required this.onConnect});

  @override
  SlackDialogState createState() => SlackDialogState();
}

class SlackDialogState extends State<SlackDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController workspaceController = TextEditingController();
  TextEditingController tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.message),
          SizedBox(width: 8),
          Text('Slack'),
        ],
      ),
      content: Column(
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
            controller: workspaceController,
            decoration: const InputDecoration(
              labelText: 'Workspace URL',
              hintText: 'Enter the Slack workspace URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: tokenController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Access Token',
              hintText: 'Enter your Slack access token',
              border: OutlineInputBorder(),
            ),
          ),
        ],
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
                workspaceController.text.isNotEmpty &&
                tokenController.text.isNotEmpty) {
              widget.onConnect(
                nameController.text,
                workspaceController.text,
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
