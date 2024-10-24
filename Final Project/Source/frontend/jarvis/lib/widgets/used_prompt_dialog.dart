import 'package:flutter/material.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/widgets/prompt_library.dart';

class UsedPromptDialog extends StatefulWidget {
  final Prompt prompt;

  const UsedPromptDialog({super.key, required this.prompt});

  @override
  State<UsedPromptDialog> createState() => _UsedPromptDialogState();
}

class _UsedPromptDialogState extends State<UsedPromptDialog> {
  TextEditingController promptController = TextEditingController();
  List<TextEditingController> inputControllerList = [];

  @override
  void initState() {
    super.initState();
    promptController.text = widget.prompt.prompt;
    for (int i = 0; i < widget.prompt.placeholders!.length; i++) {
      inputControllerList.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context);
        _returnPromptLibrary();
      },
      child: Dialog(
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
      ),
    );
  }

  void _returnPromptLibrary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return const PromptLibrary();
      },
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
            _returnPromptLibrary();
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
              child: const Text(
                "Username",
                style: TextStyle(
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
        const Text.rich(
          TextSpan(
            text: 'Input',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < inputControllerList.length; i++) ...[
          TextField(
            maxLines: 2,
            minLines: 1,
            controller: inputControllerList[i],
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.normal,
              ),
              hintText: widget.prompt.placeholders![i].keys.first,
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
        ],
        const SizedBox(height: 5),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Send prompt
            for (int i = 0; i < inputControllerList.length; i++) {
              var currentPlaceholder = widget.prompt.placeholders![i];
              String key = currentPlaceholder.keys.first;
              currentPlaceholder[key] =
                  inputControllerList[i].text; // Cập nhật giá trị
            }
            String finalPrompt = widget.prompt.getFinalPrompt();
            Navigator.pop(context, finalPrompt);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Send',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
