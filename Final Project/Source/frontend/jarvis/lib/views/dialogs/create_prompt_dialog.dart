import 'package:flutter/material.dart';
import 'package:jarvis/models/prompt.dart';

class CreatePromptDialog extends StatefulWidget {
  const CreatePromptDialog({super.key});

  @override
  State<CreatePromptDialog> createState() => _CreatePromptDialogState();
}

class _CreatePromptDialogState extends State<CreatePromptDialog> {
  Category selectedDropdownCategory = Category.Other;
  TextEditingController nameController = TextEditingController();
  TextEditingController promptController = TextEditingController();
  bool isPrivatePrompt = true;

  String? nameError;
  String? promptError;

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
            const Text(
              "New Prompt",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isPrivatePrompt,
                      onChanged: (bool? value) {
                        setState(() {
                          isPrivatePrompt = value!;
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    const Text(
                      "Private",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: isPrivatePrompt,
                      onChanged: (bool? value) {
                        setState(() {
                          isPrivatePrompt = value!;
                          selectedDropdownCategory = Category.Other;
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    const Text(
                      "Public",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Text.rich(
              TextSpan(
                text: 'Name',
                style: TextStyle(
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
              controller: nameController,
              minLines: 1,
              maxLines: null,
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
                hintText: 'Name of the prompt',
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
            if (nameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  nameError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (!isPrivatePrompt) ...[
              const SizedBox(height: 15),
              const Text.rich(
                TextSpan(
                  text: 'Category',
                  style: TextStyle(
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
              DropdownButtonFormField<Category>(
                menuMaxHeight: 200,
                decoration: InputDecoration(
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
                      color: Color.fromARGB(0, 0, 0, 0),
                      width: 1.0,
                    ),
                  ),
                ),
                dropdownColor: Colors.white,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
                value: selectedDropdownCategory,
                hint: const Text('Select a category'),
                onChanged: (Category? newValue) {
                  setState(() {
                    selectedDropdownCategory = newValue!;
                  });
                },
                items: Category.values
                    .where((category) => category != Category.All)
                    .map<DropdownMenuItem<Category>>((Category value) {
                  return DropdownMenuItem<Category>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 15),
            const Text.rich(
              TextSpan(
                text: 'Prompt',
                style: TextStyle(
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
                hintText: 'Use square brackets [ ] to specify user input.',
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
            if (promptError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  promptError!,
                  style: const TextStyle(color: Colors.red),
                ),
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
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      nameError = null; // Reset error
                      promptError = null; // Reset error

                      if (nameController.text.isEmpty) {
                        nameError = 'The field is required.';
                      }
                      if (promptController.text.isEmpty) {
                        promptError = 'The field is required.';
                      }

                      // check empty field
                      if (nameError == null && promptError == null) {
                        Navigator.of(context).pop();
                      }
                    });
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
