import 'package:flutter/material.dart';
import 'package:jarvis/models/prompt.dart';

class PublicPromptInfoDialog extends StatefulWidget {
  final Prompt prompt;

  const PublicPromptInfoDialog({
    super.key,
    required this.prompt,
  });

  @override
  State<PublicPromptInfoDialog> createState() => _PublicPromptInfoDialogState();
}

class _PublicPromptInfoDialogState extends State<PublicPromptInfoDialog> {
  late TextEditingController nameController;
  late TextEditingController promptController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    promptController = TextEditingController();

    nameController.text = widget.prompt.name;
    promptController.text = widget.prompt.prompt;
  }

  @override
  void dispose() {
    nameController.dispose();
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Title
            Text(
              widget.prompt.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            // Prompt field
            const Text.rich(
              TextSpan(
                text: 'Prompt',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: promptController,
              maxLines: 5,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.normal,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color.fromARGB(15, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(0, 0, 0, 0),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 1.0,
                  ),
                ),
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
