import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      title: const Text(
        "Error",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
      ),
      content: Text(message,
          style: const TextStyle(color: Colors.black, fontSize: 16)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ],
    );
  }
}
