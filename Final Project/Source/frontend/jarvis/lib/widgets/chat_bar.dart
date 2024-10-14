import 'package:flutter/material.dart';

class ChatBar extends StatelessWidget {
  const ChatBar({super.key});

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
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(10, 0, 0, 0),
                  filled: true,
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Start a new chat',
                  border: OutlineInputBorder(
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
              // Define action when send is pressed
            },
          ),
        ],
      ),
    );
  }
}
