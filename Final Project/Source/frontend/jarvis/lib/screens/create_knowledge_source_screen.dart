import 'package:flutter/material.dart';
import 'package:jarvis/models/knowledge_source.dart';

class CreateKnowledgeSourceScreen extends StatefulWidget {
  const CreateKnowledgeSourceScreen({super.key});

  @override
  State<CreateKnowledgeSourceScreen> createState() =>
      _CreateKnowledgeSourceScreenState();
}

class _CreateKnowledgeSourceScreenState
    extends State<CreateKnowledgeSourceScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Method to create the knowledge source
  void _createKnowledgeSource() {
    String sourceName = nameController.text.trim();
    String sourceDescription = descriptionController.text.trim();

    // Simple form validation
    if (sourceName.isEmpty || sourceName.length < 4 || sourceName.length > 20) {
      _showErrorDialog("Name must be between 4 and 20 characters.");
      return;
    }

    // If everything is valid, create the knowledge source
    KnowledgeSource newSource = KnowledgeSource(
      name: sourceName,
      description: sourceDescription.isNotEmpty
          ? sourceDescription
          : "No description provided",
      id: '', // Assign a unique ID here if needed
    );

    // Return the newly created knowledge source to the previous screen
    Navigator.pop(context, newSource);
  }

  // Method to show error dialogs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
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
        title: const Text(
          'Create Knowledge Source',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Name with asterisk
            RichText(
              text: const TextSpan(
                text: 'Name',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
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
                hintText: '4–20 characters',
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
            // Description
            RichText(
              text: const TextSpan(
                text: 'Description',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: 'Description of the Knowledge Source',
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
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap:
                  _createKnowledgeSource, // Added the function to create the knowledge source
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                child: const Center(
                  child: Text(
                    'Create Knowledge Source',
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
