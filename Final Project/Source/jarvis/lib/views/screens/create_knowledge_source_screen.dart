import 'package:flutter/material.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:jarvis/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

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
  Future<void> _createKnowledgeSource() async {
    String sourceName = nameController.text.trim();
    String sourceDescription = descriptionController.text.trim();

    // Simple form validation
    if (sourceName.isEmpty || sourceName.length < 4 || sourceName.length > 20) {
      DialogUtils.showErrorDialog(
          context, "Name must be between 4 and 20 characters.");
      return;
    }
    final knowledgeBaseProvider =
        Provider.of<KnowledgeBaseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // If everything is valid, create the knowledge source
    try {
      // Gọi API tạo Knowledge Base
      await knowledgeBaseProvider.createKnowledgeBase(
        knowledgeName: sourceName,
        description: sourceDescription.isNotEmpty
            ? sourceDescription
            : "No description provided",
        authProvider: authProvider,
      );
      await knowledgeBaseProvider.fetchKnowledgeBases(authProvider);
      // Quay lại màn hình trước và trả về knowledge source mới
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to create Knowledge Base: $e');
    }

    // KnowledgeSource newSource = KnowledgeSource(
    //   name: sourceName,
    //   description: sourceDescription.isNotEmpty
    //       ? sourceDescription
    //       : "No description provided",
    //   id: '', // Assign a unique ID here if needed
    // );

    // // Return the newly created knowledge source to the previous screen
    // Navigator.pop(context, newSource);
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
              maxLines: 1,
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
                      const BorderSide(color: Colors.black26, width: 1.0),
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
            const Text.rich(
              TextSpan(
                text: 'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: 'Optional',
                filled: true,
                fillColor: const Color.fromARGB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black26, width: 1.0),
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
