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
    promptController.text = widget.prompt.content;
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(
              height: 5,
            ),
            _buildPrompt(context),
          ],
        ),
      ),
    );
  }

  String _getLimitedText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getLimitedText(widget.prompt.name, 25),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildPrompt(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blueAccent),
              child: Text(
                widget.prompt.category.name,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12),
              child: Text(
                widget.prompt.username,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.prompt.description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
          maxLines: 15,
          minLines: 1,
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
