import 'package:flutter/material.dart';

class WebsiteDialog extends StatelessWidget {
  final Function(String name, String url) onConnect;

  const WebsiteDialog({super.key, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController urlController = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.language),
          SizedBox(width: 8),
          Text(
            'Website',
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
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter a name",
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
            controller: urlController,
            decoration: InputDecoration(
              labelText: "Website URL",
              hintText: "Enter a Website URL",
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
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () async {
            if (nameController.text.isNotEmpty &&
                urlController.text.isNotEmpty) {
              try {
                await onConnect(nameController.text, urlController.text);
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to add: $e")),
                );
              }
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
