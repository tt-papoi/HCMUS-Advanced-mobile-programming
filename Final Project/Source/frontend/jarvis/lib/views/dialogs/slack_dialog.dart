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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.folder),
          SizedBox(width: 8),
          Text(
            'Slack',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: nameController,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.normal),
              labelText: "Name",
              labelStyle: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              hintText: "Enter a name",
              filled: true,
              fillColor: const Color.fromARGB(0, 0, 0, 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black54, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: workspaceController,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.normal),
              labelText: "Workspace URL",
              labelStyle: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              hintText: "Enter the Slack workspace URL",
              filled: true,
              fillColor: const Color.fromARGB(0, 0, 0, 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black54, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: tokenController,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.normal),
              labelText: "Access Token",
              labelStyle: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              hintText: "Enter your Slack access token",
              filled: true,
              fillColor: const Color.fromARGB(0, 0, 0, 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black54, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Màu nền của nút
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Bo góc nút
            ),
          ),
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
          child: const Text(
            'Add',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
