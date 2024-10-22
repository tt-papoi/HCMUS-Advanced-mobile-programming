import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "Help",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'For any issues or support inquiries, please contact us at advancemobile.hcmus.@example.com or visit our help center HCMUS.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
