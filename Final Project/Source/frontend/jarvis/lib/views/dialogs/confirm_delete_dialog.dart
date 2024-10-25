import 'package:flutter/material.dart';

class ConfirmDeleteDialog<T> extends StatelessWidget {
  final void Function(T) onDelete;
  final String title;
  final String content;
  final T parameter;

  const ConfirmDeleteDialog({
    super.key,
    required this.onDelete,
    required this.title,
    required this.content,
    required this.parameter,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
        content,
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onDelete(parameter);
          },
        ),
      ],
    );
  }
}
