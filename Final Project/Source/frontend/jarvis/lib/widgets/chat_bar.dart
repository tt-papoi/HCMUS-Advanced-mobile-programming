import 'package:flutter/material.dart';

class ChatBar extends StatefulWidget {
  final String hintMessage;
  final Function(String) onSendMessage; // Accept a message as a parameter

  const ChatBar({
    super.key,
    required this.hintMessage,
    required this.onSendMessage,
  });

  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          // "+" Button
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Define action when "+" is pressed
            },
          ),
          // Chat Input Field (Limited height to avoid overflow)
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 120, // Limit the height to prevent overflow
              ),
              child: TextField(
                controller: _messageController,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(10, 0, 0, 0),
                  filled: true,
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: widget.hintMessage,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ),
          // Send Icon Button
          IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                widget
                    .onSendMessage(_messageController.text); // Send the message
                _messageController.clear(); // Clear the input field
              }
            },
          ),
        ],
      ),
    );
  }
}
