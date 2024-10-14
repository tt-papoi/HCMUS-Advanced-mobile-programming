import 'package:flutter/material.dart';
import 'package:jarvis/widgets/icons.dart';

class TokenUsageCard extends StatefulWidget {
  const TokenUsageCard({super.key});

  @override
  State<TokenUsageCard> createState() => _TokenUsageCardState();
}

class _TokenUsageCardState extends State<TokenUsageCard> {
  int _currentToken = 30;
  final int _maxToken = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(10, 0, 0, 0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              // Profile Icon
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 12.0),
              // User Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'trantien4868',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'trantien4868@gmail.com',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          // Token Usage and Progress Bar
          Row(
            children: [
              const Text(
                'Token Usage',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(CustomIcons.coins,
                  size: 14.0, color: Colors.deepOrange[800]),
            ],
          ),
          const SizedBox(height: 6.0),
          // Progress bar with token count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_currentToken'), // Display current token
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(50.0),
                    value: _currentToken / _maxToken,
                    backgroundColor: Colors.black12,
                    color: Colors.blueAccent,
                    minHeight: 6.0,
                  ),
                ),
              ),
              Text('$_maxToken'), // Display max token
            ],
          ),
        ],
      ),
    );
  }

  // update current token
  void updateToken(int newToken) {
    setState(() {
      _currentToken = newToken;
    });
  }
}
