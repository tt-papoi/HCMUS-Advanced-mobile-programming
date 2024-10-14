// Custom Widget for each suggestion tile
import 'package:flutter/material.dart';

class SuggestionPrompt extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap; // Function to handle tap event

  const SuggestionPrompt({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap, // Required callback function
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap, // Executes the function passed to onTap
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(10, 0, 0, 0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
