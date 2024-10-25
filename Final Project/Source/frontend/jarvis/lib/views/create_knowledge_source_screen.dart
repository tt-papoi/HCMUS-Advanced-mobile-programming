import 'package:flutter/material.dart';

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
            // Prompt with asterisk
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
                hintText: 'Descripsion of the Knowledge Base',
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
