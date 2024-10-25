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
          Icon(Icons.code),
          SizedBox(width: 8),
          Text(
            'Confluence',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        // Add this to prevent overflow
        child: Column(
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
                  borderSide:
                      const BorderSide(color: Colors.black54, width: 1.0),
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
              controller: urlController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelText: "Confluence Page URL",
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: "Enter a Confluence Page URL",
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
            ),
            const SizedBox(height: 16),
            TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: usernameController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelText: "Confluence Username",
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: "Enter a Confluence username",
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
                labelText: "Confluence Access Token",
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: "Enter a Confluence Access Token",
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
            ),
          ],
        ),
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
