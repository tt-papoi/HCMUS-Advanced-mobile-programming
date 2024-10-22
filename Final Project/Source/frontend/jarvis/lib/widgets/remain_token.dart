import 'package:flutter/material.dart';
import 'package:jarvis/widgets/icons.dart';

class RemainToken extends StatefulWidget {
  const RemainToken({super.key});

  @override
  State<RemainToken> createState() => _RemainTokenState();
}

class _RemainTokenState extends State<RemainToken> {
  int _tokenCount = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      alignment: const Alignment(0, 0),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(10, 0, 0, 0)),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
              '$_tokenCount'),
          const SizedBox(
            width: 5,
          ),
          Icon(CustomIcons.coins, size: 10, color: Colors.deepOrange[800]),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  // Update token
  void updateTokenCount(int newTokenCount) {
    setState(() {
      _tokenCount = newTokenCount;
    });
  }
}
